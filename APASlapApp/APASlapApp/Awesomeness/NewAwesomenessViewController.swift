//
//  NewAwesomenessViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class NewAwesomenessViewController: UIViewController {
    
    var databaseReference = FIRDatabase.database().reference(withPath: "awesomes")
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let userId = FIRAuth.auth()!.currentUser?.uid

        databaseReference.childByAutoId().setValue(
            ["message": messageTextView.text,
             "userId": userId]
        )
        dismiss(animated: true, completion: nil)

    }



}
