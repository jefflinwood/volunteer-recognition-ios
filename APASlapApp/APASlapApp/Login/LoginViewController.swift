//
//  LoginViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    func showNewsFeed() {
        let storyboard = UIStoryboard.init(name: "NewsFeed", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            present(vc, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let auth = FIRAuth.auth() {
            if auth.currentUser != nil {
                showNewsFeed()
            }
        }
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        
        if (emailTextField.text == "") {
            showErrorMessage(errorMessage:"Email can not be blank.")
            return
        }
        
        if (passwordTextField.text == "") {
            showErrorMessage(errorMessage:"Password can not be blank.")
            return
        }
        
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if let auth = FIRAuth.auth() {
            auth.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    self.showErrorMessage(errorMessage:error.localizedDescription)
                    return
                } else {
                    self.showNewsFeed()
                }
            })
        }
        
    }
}
