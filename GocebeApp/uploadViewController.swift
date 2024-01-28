//
//  uploadViewController.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 24.07.2023.
//

import UIKit
import Firebase
import FirebaseStorage
class uploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageViewPlace: UIImageView!
    
    @IBOutlet weak var buttonSaveOutlet: UIButton!
    @IBOutlet weak var textFieldPlaceName: UITextField!
    
    @IBOutlet weak var textFieldPlaceType: UITextField!
    
    @IBOutlet weak var textFieldComment: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewPlace.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageViewPlace.addGestureRecognizer(gestureRecognizer)
        

    }
    @objc func tapImage(){
        if textFieldPlaceName.text == "" || textFieldPlaceType.text == "" || textFieldComment.text == "" {
            user.makeAlert(title: "Hata", subTitle: "Eksik Bilgi", vc: self)
        }else{
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewPlace.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        buttonSaveOutlet.isEnabled = true
    }

    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func buttonSaveClicked(_ sender: Any) {
        self.buttonSaveOutlet.isEnabled = false
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("Media")
         
        if let data = imageViewPlace.image?.jpegData(compressionQuality : 0.5){
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data) { metaData, error in
                
                if error != nil {
                    user.makeAlert(title: "Error", subTitle: error?.localizedDescription ?? "Error", vc: self)
                }else{
                    imageReferance.downloadURL { url, error in
                        
                        if error != nil{
                            user.makeAlert(title: "Error", subTitle: error?.localizedDescription ?? "Error", vc: self)
                        }else{
                            let imageUrl = url?.absoluteString
                            let fireStoreDataBase = Firestore.firestore()
                            var fireStorereferance : DocumentReference
                            let fireStoreDataArray = ["imageUrl" : imageUrl! ,"document" : fireStoreDataBase.collection("Posts").document().documentID, "placeName" : self.textFieldPlaceName.text! , "placeType" : self.textFieldPlaceType.text! , "comment" : self.textFieldComment.text! ,"latitude" : 0.00, "longitude" : 0.00 , "date" : FieldValue.serverTimestamp()] as [String : Any]
                            fireStorereferance = fireStoreDataBase.collection("Posts").addDocument(data : fireStoreDataArray ,completion: { error in
                                if error != nil {
                                    user.makeAlert(title: "Error", subTitle: error?.localizedDescription ?? "Error ", vc: self)
                                }else{
                                    self.performSegue(withIdentifier: "toMapKitVC", sender: nil)
                                    print("Success")
                                }
                            })
                        }
                    }
                }
            }
            
            
        }
    }
    
}
