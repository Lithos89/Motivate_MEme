//
//  User.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-09.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation
import CoreData

@objc(User)

public class User: NSManagedObject {
    @NSManaged var authToken: String?
    @NSManaged var username: String
    @NSManaged var loginPreference: Bool
    
    public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "Users")
    }
    
    public func update(username: String?, authToken: String?, loginPreference: Bool?) {
        
        
        let attributes: [Any] = [username, authToken, loginPreference]
        var changes: [DataController.ValueType: Any] = [:]
        for (index, attrType) in DataController.ValueType.allCases.enumerated() {
            switch attrType {
            case .loginPreference:
                guard let val = attributes[index] as? Bool else {
                    continue
                }
                changes[attrType] = val
                break
            case .username, .authToken:
                guard let val = attributes[index] as? String else {
                    continue
                }
                changes[attrType] = val
                break
            }
        }
        
//        print(changes)
        
        DataController.shared.updateUserObject(changes: changes, user: self)
    }
}
