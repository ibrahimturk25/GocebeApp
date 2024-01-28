//
//  ListViewController.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 24.07.2023.
//

import UIKit
import Firebase
import SDWebImage
class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate {
    @IBOutlet weak var listTableView: UITableView!
    
    var imagePlaceArray = [String]()
    var documentIdArray = [String]()
    var placeNameArray = [String]()
    var idCount = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        getData()
       
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSignInVC", sender: nil)
        }catch{
            user.makeAlert(title: "Error", subTitle: error.localizedDescription, vc: self)
        }
    }
    @IBAction func buttonAdd(_ sender: Any) {
        performSegue(withIdentifier: "toUploadVC", sender: nil)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListViewCell
        cell.labelName.text = placeNameArray[indexPath.row]
        cell.imageViewPlace.sd_setImage(with: URL(string:(self.imagePlaceArray[indexPath.row])))
        cell.labelId.text = documentIdArray[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.documentId = idCount
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idCount = placeNameArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func getData(){
        let fireStoreDataBase = Firestore.firestore()
        fireStoreDataBase.collection("Posts").order(by: "date" , descending: true).addSnapshotListener { querySnapShot, error in
            if error != nil {
                user.makeAlert(title: "Error", subTitle: error?.localizedDescription ?? "Error", vc: self)
            }else{
                self.placeNameArray.removeAll(keepingCapacity: false)
                self.imagePlaceArray.removeAll(keepingCapacity: false)
                self.documentIdArray.removeAll(keepingCapacity: false)
                if querySnapShot != nil{
                    for document in querySnapShot!.documents{
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        if let placeName = document.get("placeName") as? String{
                            self.placeNameArray.append(placeName)
                            if let imagePlace = document.get("imageUrl") as? String{
                                self.imagePlaceArray.append(imagePlace)
                            }
                        }
                        
                    }
                }
                self.listTableView.reloadData()
            }
        }
    }
}
