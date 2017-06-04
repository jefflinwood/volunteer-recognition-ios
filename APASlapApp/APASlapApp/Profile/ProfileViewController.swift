//
//  ProfileViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/4/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userImagesStorageRef = FIRStorage.storage().reference().child("user-images")

    
    @IBOutlet weak var updateDisplayNameButton: UIButton!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var chooseProfilePhotoButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func updateDisplayName(_ sender: Any) {
        if let auth = FIRAuth.auth() {
            let changeRequest = auth.currentUser?.profileChangeRequest()
            changeRequest?.displayName = displayNameTextField.text
            changeRequest?.commitChanges { (error) in
                if let error = error {
                    self.showErrorMessage(errorMessage:error.localizedDescription)
                    return
                } else {
                    self.showMessage(title: "Thanks", message: "Your display name has been updated")
                }
            }
        }
    }
    
    @IBAction func chooseProfilePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleButton(button: updateDisplayNameButton)
        styleButton(button: chooseProfilePhotoButton)
        if let auth = FIRAuth.auth() {
            if let photoURL = auth.currentUser?.photoURL {
                profileImageView.sd_setImage(with: photoURL)
            } else {
                profileImageView.image = UIImage(named: "logo_apa")
            }
            if let displayName = auth.currentUser?.displayName {
                displayNameTextField.text = displayName
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //TODO: Refactor this monster!
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = image
            if let imageData = UIImageJPEGRepresentation(image,0.3) {
                let imageMetadata = FIRStorageMetadata()
                imageMetadata.contentType = "image/jpeg"
                if let auth = FIRAuth.auth() {
                    let uid = auth.currentUser!.uid
                    let uploadTask = userImagesStorageRef.child(uid).put(imageData, metadata: imageMetadata)
                
                    uploadTask.observe(.success) { snapshot in
                        self.userImagesStorageRef.child(uid).downloadURL(completion: { (downloadURL, urlError) in
                            let changeRequest = auth.currentUser?.profileChangeRequest()
                            changeRequest?.photoURL = downloadURL
                                changeRequest?.commitChanges { (error) in
                                    if let error = error {
                                        self.showErrorMessage(errorMessage:error.localizedDescription)
                                        return
                                    } else {
                                        self.showMessage(title: "Thanks", message: "Your profile photo has been updated")
                                    }
                            }
                        })
                        
                        
                    }
                }
                
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
        
    

}
