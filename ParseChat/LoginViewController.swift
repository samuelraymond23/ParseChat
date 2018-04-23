//
//  LoginViewController.swift
//  ParseChat
//
//  Created by student on 4/18/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Parse

class   LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    @IBAction func signUp(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = username.text
        //newUser.email = emailLabel.text
        newUser.password = password.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                if self.username.text == "" {
                    let alertController = UIAlertController(title: "Email required", message: error as! String!, preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
                }
                else if self.password.text == "" {
                    
                    let alertController = UIAlertController(title: "Password required", message: error as! String!, preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
        
            }
        }
    }
        

    }
    
    
    @IBAction func login(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: username.text!, password: password.text!) { (user:PFUser?, error) in
            if user != nil {
                print("you logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let chatViewController = storyboard.instantiateViewController(withIdentifier: "chatNav") as! UINavigationController
                self.present(chatViewController, animated: true, completion: nil)
                
                
                
            } else if let error = error {
                let errorMessage = error.localizedDescription
                print(errorMessage)
                
                
                if self.username.text == "" {
                    let alertController = UIAlertController(title: "Email required", message: errorMessage as String!, preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
                }
                else if self.password.text == "" {
                    
                    let alertController = UIAlertController(title: "Password required", message: errorMessage as String!, preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                      
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
    
}
     




