//
//  LoadingVC.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-28.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var habits: [Habit]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if habits != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "FinishedLoadingInitialHabits", sender: nil)
                print("good")
            }
        } else {
            if let habits = InfoNetworkingController.getHabits(numberOfHabits: 5) {
                self.habits = habits
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "FinishedLoadingInitialHabits", sender: nil)
                }
            } else {
                print("not interested")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishedLoadingInitialHabits", let tableVC = segue.destination as? HabitsTableVC {
            if let habits = habits {
                tableVC.habits = habits
                print(habits)
            }
        }
    }

}
