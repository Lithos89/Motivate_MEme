//
//  LoginVC.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-08.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let loginController = AuthNetworkingController.LoginNetworking.self

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        view.layer.contents = #imageLiteral(resourceName: "Login Background").cgImage
        
        //Stackview Spacing
//        stackView.setCustomSpacing(<#T##spacing: CGFloat##CGFloat#>, after: <#T##UIView#>)
        stackView.setCustomSpacing(34.0, after: usernameField)
        stackView.setCustomSpacing(70.0, after: passwordField)
        stackView.setCustomSpacing(35.0, after: loginButton)
        
        //Inset Setup
        usernameField.layer.cornerRadius = 5
        passwordField.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 22
        signupButton.layer.cornerRadius = 22
        
        //Border Setup
        usernameField.layer.borderWidth = 2
        usernameField.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        
        passwordField.layer.borderWidth = 2
        passwordField.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        
        signupButton.layer.borderWidth = 3
        signupButton.layer.borderColor = CGColor(srgbRed: 56.0/255.0, green: 48.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let _username: String = usernameField.text ?? ""
        let _password: String = passwordField.text ?? ""
        
        loginController.attemptLogin(username: _username, password: _password) { result in
            print(result)
            if (result) {
                self.performSegue(withIdentifier: "SuccessfulLogin", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SuccessfulLogin") {
            let contentStoryboard: UIStoryboard = UIStoryboard(name: "Content", bundle: nil)
            let mainTableViewController = contentStoryboard.instantiateInitialViewController()
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            keyWindow?.rootViewController = mainTableViewController
        }
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
