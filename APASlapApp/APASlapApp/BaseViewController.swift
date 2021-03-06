//
//  BaseViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class BaseViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func styleTopToolbar(topToolbarView: UIView) {
        topToolbarView.layer.shadowOffset = CGSize(width: 0, height: 0.4)
        topToolbarView.layer.shadowRadius = 4.0
        topToolbarView.layer.shadowColor = UIColor.black.cgColor
        topToolbarView.layer.shadowOpacity = 0.6
    }

    func styleButton(button: UIButton) {
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4.0
    }
    
    func showErrorMessage(errorMessage:String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


}
