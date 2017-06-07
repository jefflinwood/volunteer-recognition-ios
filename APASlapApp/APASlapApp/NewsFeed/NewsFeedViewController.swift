//
//  NewsFeedViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import DateToolsSwift
import FaveButton
import Firebase
import FirebaseStorageUI

class NewsFeedViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FaveButtonDelegate {
    
    var databaseReference = FIRDatabase.database().reference(withPath: "awesomes")
    let imagesStorageRef = FIRStorage.storage().reference().child("images")

    var awesomes = [[String:AnyObject]]()
    
    
    @IBOutlet weak var plusButton: FaveButton!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var topToolbarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
        plusButton.delegate = self
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        styleTopToolbar(topToolbarView: topToolbarView)
        
        // Watch for new awesomes!
        databaseReference.observe(.childAdded, with: { (snapshot) -> Void in
            var data = snapshot.value as! [String:AnyObject]
            data["awesomeKey"] = snapshot.key as AnyObject
            self.awesomes.insert(data, at: 0)
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
        let displayName = awesome["authorDisplayName"] as? String
        let authorPhotoURL = awesome["authorPhotoURL"] as? String
        var timeAgo = ""
        if let timestamp = awesome["timestamp"] as? NSNumber {
            let awesomeDate = Date(timeIntervalSince1970: timestamp.doubleValue)
            timeAgo = awesomeDate.shortTimeAgoSinceNow
        }
        
        if awesome["volunteerDisplayName"] != nil {
            let volunteerDisplayName = awesome["volunteerDisplayName"] as! String
            cell.volunteerDisplayNameLabel.text =  "\(volunteerDisplayName) was awesome!"
        } else {
            cell.volunteerDisplayNameLabel.text = ""
        }
        
        if let displayName = displayName {
            cell.titleLabel.text = "\(displayName) SLAPped \(timeAgo)"
        } else {
            cell.titleLabel.text = "SLAPped"
        }
        
        if let authorPhotoURL = authorPhotoURL {
            let url = URL(string: authorPhotoURL)
            cell.authorImageView.sd_setImage(with: url, placeholderImage: nil)
        } else {
            cell.authorImageView.image = UIImage(named: "logo_apa")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "AwesomeDetail", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? AwesomeDetailViewController {
            vc.awesome = awesomes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        faveButton.isSelected = false
        let storyboard = UIStoryboard.init(name: "NewAwesomeness", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            present(vc, animated: false, completion: nil)
        }
    }

}
