//
//  InfoNetworkingController.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-25.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation
import SwiftyJSON

class InfoNetworkingController: NetworkingController {
    
    typealias JSONDictionary = [String: Any]
    
    static func getHabits(numberOfHabits amount: Int) -> [Habit]? {
        
        print("G")
        
        //Might have to modify either here or in scene delegate to provide better error handling
        guard let authToken = DataController.shared.getUserObject()?.authToken else {
            print("Bad")
            return nil
        }
        
        let headers: [String : String] = [
            "Authorization": "Bearer \(authToken)",
            "Content-Type": "application/json"
        ]
        
        var retrievedHabits: [Habit]? = nil
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .utility).async {
            let getHabitsTask = executeURLRequest(urlPath: URLData.habits, headers: headers) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        retrievedHabits = try convertJSONToHabits(data: data)
                        group.leave()
                    } catch let parseError {
                        print(parseError.localizedDescription)
                        group.leave()
                    }
                }
            }
            if let task = getHabitsTask {
                task.resume()
            } else {
                group.leave()
            }
        }
        
        group.wait()
        print(retrievedHabits ?? "no habits")
        return retrievedHabits
    }
    
    private static func convertJSONToHabits(data: Data) throws -> [Habit] {
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        
        guard let array = json!["habits"] as? [Any] else {
            print("Dictionary does not contain results key\n")
            throw NSError()
        }
        var retrievedHabits = [Habit]()
        for habit in array {
            if let habit = habit as? JSONDictionary,
            let name = habit["habit_name"] as? String,
            let start = habit["start_date"] as? String,
            let id = habit["criteria_id"] as? Int {
                let attempt = habit["attempt"] as? Int
                let note = habit["note"] as? String
                retrievedHabits.append(Habit(name: name, start: start, attempt: attempt, id: id, note: note))
            }
        }
        
        return retrievedHabits
    }
}
