//
//  Habit.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-28.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation

struct Habit: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case name = "habit_name"
        case start = "start_date"
        case attempt
        case id = "criteria_id"
        case note
    }
    let name: String
    let start: String
    let attempt: Int?
    let id: Int
    let note: String?
}
