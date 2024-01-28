//
//  DetailsViewController.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 31.07.2023.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
class DetailsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var imageViewPlace: UIImageView!
    @IBOutlet weak var labelx: UILabel!
    @IBOutlet weak var labely: UILabel!
    @IBOutlet weak var mapKitPlace: MKMapView!
    @IBOutlet weak var labelPlaceComment: UILabel!
    @IBOutlet weak var labelPlaceType: UILabel!
    @IBOutlet weak var labelPlaceName: UILabel!
    var locationManager = CLLocationManager()
    var documentId = ""
    var latitudex :Double = 0
    var longitudey : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitPlace.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        getData()
    }
   

    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    
    @objc func getData(){
        let fireStoreDataBase = Firestore.firestore()
        fireStoreDataBase.collection("Posts").whereField("placeName", isEqualTo: documentId).addSnapshotListener { querySnapShot, error in
            if error != nil {
                user.makeAlert(title: "Error", subTitle: error?.localizedDescription ?? "Error", vc: self)
            }else{
                if querySnapShot != nil{
                    for document in querySnapShot!.documents{
                        if let placeName = document.get("placeName") as? String{
                            self.labelPlaceName.text = placeName
                            if let placeType = document.get("placeType") as? String{
                                self.labelPlaceType.text = placeType
                                if let placeComment = document.get("comment") as? String{
                                    self.labelPlaceComment.text = placeComment
                                    if let imageUrl = document.get("imageUrl") as? String{
                                        self.imageViewPlace.sd_setImage(with: URL(string: imageUrl))
                                        if let latitude = document.get("latitude") as? Double{
                                            self.labelx.text = String(latitude)
                                            if let longitude = document.get("longitude") as? Double{
                                                self.labely.text = String(longitude)
                                                let annotation = MKPointAnnotation()
                                                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                                annotation.coordinate = coordinate
                                                annotation.title = placeName
                                                self.latitudex = latitude
                                                self.longitudey = longitude
                                                self.mapKitPlace.addAnnotation(annotation)
                                                let location = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
                                                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                                let region = MKCoordinateRegion(center: location, span: span)
                                                self.mapKitPlace.setRegion(region, animated: true)
//                                                self.locationManager.stopUpdatingLocation()
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "Map"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .blue
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let requestLocation = CLLocation(latitude: latitudex, longitude: longitudey)
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
            if let placemark = placemarks{
                if placemark.count > 0 {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.documentId
                    let launcOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launcOptions)
                }
            }
        }
    }


}
