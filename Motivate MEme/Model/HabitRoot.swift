//
//  HabitRoot.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-30.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation

struct HabitRoot: Decodable {
    private enum CodingKeys: String, CodingKey {
//        case habitsCount = "count"
        case habits
    }
    
//    let habitsCount : Int
    let habits : [Habit]
}
