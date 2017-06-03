//
//  NewsFeedViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import FaveButton
import Firebase
import FirebaseStorageUI

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var databaseReference = FIRDatabase.database().reference(withPath: "awesomes")
    let imagesStorageRef = FIRStorage.storage().reference().child("images")

    var awesomes = [[String:AnyObject]]()
    
    @IBOutlet weak var plusButton: FaveButton!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Watch for new awesomes!
        databaseReference.observe(.childAdded, with: { (snapshot) -> Void in
            self.awesomes.insert(snapshot.value as! [String:AnyObject], at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awesomes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:AwesomeCell
        let awesome = awesomes[indexPath.row]
        if (awesome["imageStorageRefId"] != nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "AwesomeCellWithImage", for: indexPath) as! AwesomeCell
            let reference = imagesStorageRef.child(awesome["imageStorageRefId"] as! String)
            let placeholderImage = UIImage(named: "logo_apa")

            cell.messageImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AwesomeCell", for: indexPath) as! AwesomeCell
            cell.messageImageView.image = nil
        }
        cell.messageLabel.text = awesome["message"] as? String

        
        return cell
    }

}
