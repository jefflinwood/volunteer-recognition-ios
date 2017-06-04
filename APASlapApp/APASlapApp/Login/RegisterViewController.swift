//
//  RegisterViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class RegisterViewController: BaseViewController {
    
    var usersReference = FIRDatabase.database().reference(withPath: "users")

    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if (passwordTextField.text == "" && confirmPasswordTextField.text == "") {
            showErrorMessage(errorMessage:"Password can not be blank.")
            return
        }
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            showErrorMessage(errorMessage:"Passwords have to match. Please try again.")
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let fullName = fullNameTextField.text!
        
        if let auth = FIRAuth.auth() {
            auth.createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.showErrorMessage(errorMessage:error.localizedDescription)
                    return
                } else {
                    //save user data like the full name
                    let changeRequest = auth.currentUser?.profileChangeRequest()
                    changeRequest?.displayName = fullName
                    changeRequest?.commitChanges { (error) in
                        if let error = error {
                            self.showErrorMessage(errorMessage:error.localizedDescription)
                            return
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
            }

        } else {
            showErrorMessage(errorMessage:"Unable to process signup")
        }
        
    }

  

}
