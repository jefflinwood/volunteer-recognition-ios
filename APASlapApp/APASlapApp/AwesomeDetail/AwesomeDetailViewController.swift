//
//  AwesomeDetailViewController.swift
//  
//
//  Created by Jeffrey Linwood on 6/4/17.
//
//

import UIKit

import Firebase

class AwesomeDetailViewController: BaseViewController {
    
    let imagesStorageRef = FIRStorage.storage().reference().child("images")
    var databaseReference = FIRDatabase.database().reference(withPath: "awesomes")

    
    var awesome:[String:Any] = [String:Any]()
    
    
    @IBOutlet weak var topToolbarView: UIView!
    
    @IBOutlet weak var claimButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var authorImageView: UIImageView!

    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func claim(_ sender: Any) {
        var data = [String:String]()
        if let currentUser = FIRAuth.auth()!.currentUser {
            data["volunteerId"] = currentUser.uid
            if let displayName = currentUser.displayName {
                data["volunteerDisplayName"] = displayName
            }
            if let photoURL = currentUser.photoURL {
                data["volunteerPhotoURL"] = photoURL.absoluteString
            }
            
            databaseReference.child(awesome["awesomeKey"] as! String).updateChildValues(data, withCompletionBlock: { (error, reference) in
                self.showMessage(title: "Claimed!", message: "Thank you for volunteering")
            })
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleTopToolbar(topToolbarView: topToolbarView)
        styleButton(button: claimButton)
        populateUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateUI() {
        if (awesome["imageStorageRefId"] != nil) {
            let reference = imagesStorageRef.child(awesome["imageStorageRefId"] as! String)
            let placeholderImage = UIImage(named: "logo_apa")
            messageImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        } else {
            
            messageImageView.image = nil
        }
        messageLabel.text = awesome["message"] as? String
        let displayName = awesome["authorDisplayName"] as? String
        let authorPhotoURL = awesome["authorPhotoURL"] as? String
        var timeAgo = ""
        if let timestamp = awesome["timestamp"] as? NSNumber {
            let awesomeDate = Date(timeIntervalSince1970: timestamp.doubleValue)
            timeAgo = awesomeDate.timeAgoSinceNow
        }
        
        if let displayName = displayName {
            titleLabel.text = "\(displayName) SLAPped \(timeAgo)"
        } else {
            titleLabel.text = "SLAPped"
        }
        
        if let authorPhotoURL = authorPhotoURL {
            let url = URL(string: authorPhotoURL)
            authorImageView.sd_setImage(with: url, placeholderImage: nil)
        } else {
            authorImageView.image = UIImage(named: "logo_apa")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
