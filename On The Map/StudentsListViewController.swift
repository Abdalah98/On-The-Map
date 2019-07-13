//
//  StudentsListViewController.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.

import Foundation
import UIKit

class StudentsListViewController: UIViewController {
    var studentLocations: [LocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let apiService = DataProviderService()
        apiService.getStudentLocations {[weak self] locationsList, error  in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                } else  {
                    self?.studentLocations = locationsList ?? []
                    self?.tableView.reloadData()
                }
            }
            
        }

    }
    
   
    @IBOutlet var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(studentLocations.count)

    }
  
    @IBAction func Logout(_ sender: Any) {
        
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
        loadLocation()
    }
    
    func loadLocation() {
        let apiService = DataProviderService()
        apiService.getStudentLocationsLimit { [weak self] locationsList, error  in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                } else  {
                    self?.studentLocations = locationsList ?? []
                    self?.tableView.reloadData()
                }
            }
            
        }
            
        }

    
    
    
    
    @IBAction func PostLocation(_ sender: Any) {
    
    let viewController = storyboard?.instantiateViewController(withIdentifier: "new") as? PostLocationViewController
        self.present(viewController!, animated: true, completion: nil)
    }
    
    func alertMessage(title: String , error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
}



extension StudentsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as? StudentCellTableViewCell
        let studentLocation = studentLocations[indexPath.row]
        cell?.name.text = (studentLocation.firstName ?? "") + " " + (studentLocation.lastName ?? "")
        cell?.url.text = studentLocation.mediaURL ?? ""
        return cell!
    }
}
extension StudentsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = studentLocations[indexPath.row].mediaURL {
            if(mediaURL.contains("http")){
                let url = URL(string: mediaURL)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }else{
                alertMessage(title: "Error", error: "This is not a valid URL , try another one!")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
    


