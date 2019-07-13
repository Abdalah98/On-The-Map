//
//  MapViewController.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.

import Foundation
import UIKit
import MapKit
    
class MapViewController: UIViewController {
    var studentLocations: [LocationModel] = []

        var annotations: [MKPointAnnotation] = []
        //MARK: - IBOutlets
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            NetworkManager.shared.getLocations { pointAnnotationList, error  in
                DispatchQueue.main.async {
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "")", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if let pointAnnotationList = pointAnnotationList {
                            self.annotations = pointAnnotationList
                            self.map.addAnnotations(self.annotations)
                            self.map.reloadInputViews()
                        }
                    }
                    
                    
                }
            }
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        }
    
    //MARK:- Actions
    @IBAction func logout(_ sender: Any) {
        
        let apiService = DataProviderService()
        apiService.logout { (isSuccess) in
            if isSuccess {
                if let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.present(loginViewController, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Something Goes Wrong", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        NetworkManager.shared.getLocationsLimit { pointAnnotationList, error  in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "")", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if let pointAnnotationList = pointAnnotationList {
                        self.annotations = pointAnnotationList
                        self.map.addAnnotations(self.annotations)
                        self.map.reloadInputViews()
                    }
                }
                
                
            }
        }
    }
    
    @IBAction func AddLocation(_ sender: Any) {
         let viewController = storyboard?.instantiateViewController(withIdentifier:"new") as? PostLocationViewController
            self.present(viewController!, animated: true)
    }
        
}
    
    extension MapViewController: MKMapViewDelegate {
        // MARK: - MKMapViewDelegate Methods
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            print("view")
            let reuseID = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                pinView!.annotation = annotation
            }
            return pinView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            print("hiiiiii")
            if control == view.rightCalloutAccessoryView  {
                let link = view.annotation?.subtitle
                if(link!!.contains("http")){
                    let url = URL(string: link as! String)
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    
                }else{
                    alertMessage(title: "Error", error: "This is not a valid URL , try another one!")
                }
            }
        }
        
        func alertMessage(title: String , error: String){
            let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil)
        }
        
}


