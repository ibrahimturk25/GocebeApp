//
//  ListViewCell.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 25.07.2023.
//

import UIKit
import Firebase
class ListViewCell: UITableViewCell {

    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewPlace: UIImageView!
    @IBOutlet weak var imagePlace: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonDelete(_ sender: Any) {
        let fireStoreDAtaBAse = Firestore.firestore()
        let viewContollerAlert = UIViewController()
        let alert = UIAlertController(title: "Silme", message: "Silmek istedipinizden eminmisiniz", preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "Delete", style: .default)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        viewContollerAlert.present(alert, animated: true)
        fireStoreDAtaBAse.collection("Posts").document(labelId.text!).delete { error in
            if error != nil{
                print("Error")
            }else{
                
            }
        }
    }
    
}
