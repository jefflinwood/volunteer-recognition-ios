//
//  NewAwesomenessViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class NewAwesomenessViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let databaseReference = FIRDatabase.database().reference(withPath: "awesomes")
    
    let imagesStorageRef = FIRStorage.storage().reference().child("images")
    
    var imageStorageRefId:String?

    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var addAPhotoButton: UIButton!
    
    @IBOutlet weak var takeAPhotoButton: UIButton!
    
    @IBOutlet weak var tagVolunteersButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleButton(button: addAPhotoButton)
        styleButton(button: takeAPhotoButton)
        styleButton(button: tagVolunteersButton)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let currentUser = FIRAuth.auth()!.currentUser
        let authorId = currentUser?.uid
        
        
        var data = ["message": messageTextView.text,
                    "authorId": authorId,
                    "timestamp": NSDate().timeIntervalSince1970] as [String : Any]
        
        if let authorDisplayName = currentUser?.displayName {
            data["authorDisplayName"] = authorDisplayName
        } else {
            data["authorDisplayName"] = currentUser?.email
        }
        
        if let authorPhotoURL = currentUser?.photoURL {
            data["authorPhotoURL"] = authorPhotoURL.absoluteString
        }
        
        if let imageStorageRefId = imageStorageRefId {
            data["imageStorageRefId"] = imageStorageRefId
        }

        databaseReference.childByAutoId().setValue(
            data
        )
        dismiss(animated: true, completion: nil)

    }


    @IBAction func addAPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func useCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func tapView(_ sender: Any) {
        messageTextView.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = image
            if let imageData = UIImageJPEGRepresentation(image,0.3) {
                let imageMetadata = FIRStorageMetadata()
                imageMetadata.contentType = "image/jpeg"
                let imagePath = NSUUID().uuidString
                let uploadTask = imagesStorageRef.child(imagePath).put(imageData, metadata: imageMetadata)
                
                uploadTask.observe(.success) { snapshot in
                    self.imageStorageRefId = imagePath
                    print("Uploaded image")
                }
                

            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
