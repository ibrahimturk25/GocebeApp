//
//  AuthUser.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 24.07.2023.
//

import Foundation
import Firebase
class user{
    

    class func makeAlert(title : String, subTitle : String , vc : UIViewController){
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(okButton)
        vc.present(alert, animated: true)
        
    }
}
