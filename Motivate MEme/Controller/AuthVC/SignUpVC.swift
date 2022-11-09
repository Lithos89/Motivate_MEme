//
//  SignUpVC.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-08.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import UIKit
import Alamofire



class SignUpVC: UIViewController {
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var stackVIew: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Makes navigation bar background invisible
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //Create label dropshadow
        
        signupLabel.layer.shadowColor = UIColor.black.cgColor
        signupLabel.layer.shadowRadius = 2.0
        signupLabel.layer.shadowOpacity = 0.4
        signupLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        signupLabel.layer.masksToBounds = false
        
        //Stackview custom spacing
        stackVIew.setCustomSpacing(200.0, after: signupLabel)
        stackVIew.setCustomSpacing(34.0, after: usernameField)
        stackVIew.setCustomSpacing(70.0, after: passwordField)
        
        //Add inset
        usernameField.layer.cornerRadius = 5.0
        passwordField.layer.cornerRadius = 5.0
        submitButton.layer.cornerRadius = 22.0
        
        //Add Borders
        usernameField.layer.borderWidth = 2
        passwordField.layer.borderWidth = 2
        
        usernameField.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        passwordField.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        
        submitButton.layer.borderWidth = 3.0
        submitButton.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        
        //Add background image
        view.layer.contents = #imageLiteral(resourceName: "Signup Background").cgImage
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

