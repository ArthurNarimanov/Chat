//
//  LoginController+handlers.swift
//  Chat
//
//  Created by Ram on 19/08/2019.
//  Copyright © 2019 New tec. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                print("From is not valid")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            if error != nil {
                print(error as Any)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = self.profileImageView.image?.pngData(){
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata,  error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, err) in
                        if err != nil {
                            print(err as Any)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://chat-35ca2.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)

        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err as Any)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
/*
 
 let storage = Storage.storage()
 let storageRef = storage.reference()
 let photoIdString = "\(NSUUID().uuidString).jpg"
 let imageReference = storageRef.child("posts").child(photoIdString)
 if let imageData = UIImageJPEGRepresentation(selectedImage, 0.7) {
 imageReference.putData(imageData).observe(.success) { (snapshot) in
 imageReference.downloadURL(completion: { (url, error) in
 
 if let downloadUrl = url {
 
 let directoryURL : NSURL = downloadUrl as NSURL
 let urlString:String = directoryURL.absoluteString!
 self.sendDataToDatabase(photoUrl: urlString)
 }
 else {
 print("couldn't get profile image url")
 return
 }
 })

You'll need to add 'Firebase/Core' to your pods and run 'pod update'.
 */
