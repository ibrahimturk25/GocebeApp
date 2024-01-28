//
//  ViewController.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 24.07.2023.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var textFİeldUsername: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonGiris(_ sender: Any) {
        if textFİeldUsername.text != "" || textFieldPassword.text != ""{
            Auth.auth().signIn(withEmail: textFİeldUsername.text!, password: textFieldPassword.text!) { authData, error in
                if error != nil{
                    self.makeAlert(title: "Error", subTitle: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toListVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func buttonKayit(_ sender: Any) {
        if textFİeldUsername.text != "" || textFieldPassword.text != ""{
            Auth.auth().createUser(withEmail: textFİeldUsername.text!, password: textFieldPassword.text!) { authData, error in
                if error != nil {
                    user.makeAlert(title: "Hata", subTitle: error?.localizedDescription ?? "Error", vc: self)
                }else{
                    self.performSegue(withIdentifier: "toListVC", sender: nil)
                }
            }
        }
        else{
            user.makeAlert(title: "Hata", subTitle: "Bilgileri Giriniz", vc: self)
        }
    }
    func makeAlert(title : String, subTitle : String){
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(okButton)
        present(alert, animated: true)
        
    }

}

