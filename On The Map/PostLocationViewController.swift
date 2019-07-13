//
//  PostLocationViewController.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.


import Foundation
import UIKit
import MapKit

class PostLocationViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var studentsLocation: UITextField!
    @IBOutlet weak var studentsURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var location: CLLocationCoordinate2D? = CLLocationCoordinate2D()
    var mapName: String?
    var mapURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsLocation.delegate = self
        studentsURL.delegate = self
        mapView.isHidden = true
        studentsLocation.isHidden = false
        studentsURL.isHidden = false
        finishButton.isHidden = true
    }
    
    @IBAction func performForwardGeocoding() {
        if studentsLocation.text != "" && studentsURL.text != "" {
            self.mapName = studentsLocation.text!
            self.mapURL = studentsURL.text!
            
            let usersLocation = self.studentsLocation.text
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(usersLocation!) { placemarks, error in
                guard error == nil
                    else{
                        self.alertMessage(title: "Oops!", error: "Can't find your location")
                        return
                }
                guard let placemark = placemarks?.first
                    else {return}
                self.location = placemark.location?.coordinate
                self.mapView.isHidden = false
                self.studentsLocation.isHidden = true
                self.studentsURL.isHidden = true
                self.finishButton.isHidden = false
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.studentsURL.resignFirstResponder()
                self.studentsLocation.resignFirstResponder()
                
            }
        }else {
            alertMessage(title: "Error", error: "No Location or URL Added , Please enter your location and a URL")
            //print("No Location or URL Added", "Please enter your location and a URL.")
        }
        
    }
    
    
    func alertMessage(title: String , error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func postNewLocation() {
        let apiService = DataProviderService()
        apiService.postStudentLocations(map: mapName ?? "", url: mapURL ?? "", lat: location?.latitude ?? 0.0, lng: location?.longitude ?? 0.0) { (isSuccess) in
            DispatchQueue.main.async {
                if (isSuccess) {
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.alertMessage(title: "Error", error: "Can't save location, try again later")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)
        return true
    }
    
}

