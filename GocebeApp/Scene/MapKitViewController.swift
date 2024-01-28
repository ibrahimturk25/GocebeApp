//
//  MapKitViewController.swift
//  GocebeApp
//
//  Created by İbrahim Türk on 24.07.2023.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MapKitViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapKitConroller: MKMapView!
    var locationManager = CLLocationManager()
    var latitudex :Double = 0
    var longitudey : Double = 0
    var annotationTitle = ""
    var touchedCount = 0
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        mapKitConroller.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 1
        mapKitConroller.addGestureRecognizer(gestureRecognizer)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKitConroller.setRegion(region, animated: true)
    }
    
    @objc func longPress(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            if touchedCount == 0{
                let touchedPoint = gestureRecognizer.location(in: self.mapKitConroller)
                let touchedCoordinate = self.mapKitConroller.convert(touchedPoint, toCoordinateFrom: self.mapKitConroller)
                latitudex = touchedCoordinate.latitude
                longitudey = touchedCoordinate.longitude                                                                              //Koordinatları değere atadım
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = touchedCoordinate
                annotation.title = "Yeni Konum"
                annotation.subtitle = "Deneme"
                self.mapKitConroller.addAnnotation(annotation)
                touchedCount = 1
            }
            else{
                user.makeAlert(title: "Error", subTitle: "You cannot select more than 1 coordinate", vc: self)
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
                    item.name = self.annotationTitle
                    let launcOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launcOptions)
                }
            }
        }
    }
    


    @IBAction func buttonSave(_ sender: Any) {
        if latitudex == 0 || longitudey == 0 {
            user.makeAlert(title: "Error", subTitle: "Konum Seçiniz", vc: self)
        }else{
            let fireStoreDataBase = Firestore.firestore()
            fireStoreDataBase.collection("Posts").whereField("latitude", isEqualTo: 0.00).whereField("longitude", isEqualTo: 0.00).getDocuments(completion: ) { querySnapShot, error in
                if error != nil{
                    print("Error")
                    
                }else{
                    let latitudeStore = ["latitude": self.latitudex] as [String : Any]
                    let longitudeStore = ["longitude" : self.longitudey] as [String : Any]
                    if let x = querySnapShot?.documents.first{
                        let y = x.documentID
                        
                        fireStoreDataBase.collection("Posts").document(y).setData(latitudeStore,merge: true)
                        fireStoreDataBase.collection("Posts").document(y).setData(longitudeStore,merge: true)
                        self.performSegue(withIdentifier: "toListVC", sender: nil)
                        
                    }else{
                        print("hata")
                    }
                }
            }
        }
    }
}
