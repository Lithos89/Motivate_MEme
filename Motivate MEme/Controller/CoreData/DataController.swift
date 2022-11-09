//
//  DataController.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-17.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation
import CoreData

class DataController: NSObject {
    
    private let modelName: String

    private init(_ modelName: String) {
        self.modelName = modelName
    }

    static let shared = DataController("Motivate_MEme")
    
    
    @objc func saveChanges() {
        managedObjectContext.perform {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
            
            self.privateManagedObjectContext.perform {
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    print("\(saveError), \(saveError.localizedDescription)")
                }
            }
        }
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
         let fileManager = FileManager.default
           let storeName = "\(self.modelName).sqlite"

           let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

           let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

           do {
               let options = [ NSInferMappingModelAutomaticallyOption : true, NSMigratePersistentStoresAutomaticallyOption : true]

               try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
           } catch {
               fatalError("Unable to Load Persistent Store")
           }
           
           return persistentStoreCoordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "Motivate_MEme", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext =  {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return privateManagedObjectContext
    }()
//    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

    func setup(setupClosure: @escaping (DataController) -> ()) {
        setupClosure(self)
    }
    

    enum ValueType: String, CaseIterable {
        case username = "username"
        case authToken = "authToken"
        case loginPreference = "loginPreference"
    }

    func createUserObject(username: String, authToken: String?, loginPreference: Bool?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: self.privateManagedObjectContext) else {
            return
        }
        let newUser = NSManagedObject(entity: entity, insertInto: self.privateManagedObjectContext)

        newUser.setValue(username, forKey: ValueType.username.rawValue)
        if let authToken = authToken {
            newUser.setValue(authToken, forKey: ValueType.authToken.rawValue)
        }
        if let loginPreference = loginPreference {
            newUser.setValue(loginPreference, forKey: ValueType.loginPreference.rawValue)
        }

        self.saveChanges()
    }


    func updateUserObject(changes: [ValueType: Any], user: User) {
        persistentStoreCoordinator.perform {
            for attr in changes {
                print(attr)
                switch attr.key {
                case .username, .authToken:
                    let stringDesc: String? = String(describing: attr.value)
                    if let val = stringDesc {
                        print(val)
                        user.setValue(val, forKey: attr.key.rawValue)
                    }
                case .loginPreference:
                    user.setValue(attr.value as! Bool, forKey: attr.key.rawValue)
                }
            }
            self.saveChanges()
        }
    }

    func getUserObject() -> User? {
        var user: User?
        let group = DispatchGroup()
        group.enter()
        persistentStoreCoordinator.perform {
            let request = NSFetchRequest<User>(entityName: "User")

            do {
                let userObjectArray = try self.privateManagedObjectContext.fetch(request)
                if let userObject = userObjectArray.first {
                    user = userObject
                    group.leave()
                } else {
                    user = nil
                    group.leave()
                }
            } catch {
               fatalError("Error retrieving user from managed object context")
            }
        }
        group.wait()
        return user
    }

}


//class DataController: NSObject {
//
//    static let persistentContainer = NSPersistentContainer(name: "Motivate_MEme")
//    static var managedObjectContext: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    init(completionClosure: @escaping () -> ()) {
//        DataController.persistentContainer.loadPersistentStores { (description, error) in
//            if let error = error {
//                fatalError("\(error)")
//            }
//
//            completionClosure()
//        }
//    }
//
//    internal static func saveContext () {
//        if DataController.managedObjectContext.hasChanges {
//            do {
//                try DataController.managedObjectContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
//
//    public class UserObject {
//
//        enum ValueType: String, CaseIterable {
//            case username = "username"
//            case authToken = "authToken"
//            case loginPreference = "loginPreference"
//        }
//
//        static func createUserObject(username: String, authToken: String?, loginPreference: Bool?) {
//            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
//                return
//            }
//            let newUser = NSManagedObject(entity: entity, insertInto: managedObjectContext)
//
//            newUser.setValue(username, forKey: ValueType.username.rawValue)
//            if let authToken = authToken {
//                newUser.setValue(authToken, forKey: ValueType.authToken.rawValue)
//            }
//            if let loginPreference = loginPreference {
//                newUser.setValue(loginPreference, forKey: ValueType.loginPreference.rawValue)
//            }
//
//            saveContext()
//        }
//
//
//        static func updateUserObject(changes: [ValueType: Any], user: User) {
//            for attr in changes {
//                print(attr)
//                switch attr.key {
//                case .username, .authToken:
//                    let stringDesc: String? = String(describing: attr.value)
//                    if let val = stringDesc {
//                        print(val)
//                        user.setValue(val, forKey: attr.key.rawValue)
//                    }
//                case .loginPreference:
//                    user.setValue(attr.value as! Bool, forKey: attr.key.rawValue)
//                }
//            }
//            saveContext()
//        }
//
//        public static func getUserObject() -> User? {
//            let request = NSFetchRequest<User>(entityName: "User")
//
//            do {
//                let userObjectArray = try DataController.managedObjectContext.fetch(request)
//                if let userObject = userObjectArray.first {
//                    return userObject
//
//                } else {
//                    return nil
//                }
//            } catch {
//               fatalError("Error retrieving user from managed object context")
//            }
//        }
//    }
//
//}
