//
//  ViewController.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.


import UIKit

class DataProviderService: UIViewController {

    //Mark:- Authentication
    func authenticate(username: String , password: String , completion: @escaping (AuthModel? , Error?) -> Void){
        if let loginURL = URL(string : EndPointURL.auth){
            var request = URLRequest(url: loginURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["udacity" : [
                "username": username ,
                "password": password
                ]]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch let error {
                completion(nil,error)
            }
            
            let task = URLSession.shared.dataTask(with: request) {data , response , error in
                if error != nil {
                    completion(nil , error)
                    return
                }else {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode == 200
                        else {
                            let error  = NSError(domain: "Auth Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Account not found or invalid credentials"])
                            completion(nil , error)
                            return
                    }
                    if let data = data {
                        let range = Range(5..<data.count)
                        let usableResult = data.subdata(in: range)
                        do {
                            let authModel = try JSONDecoder().decode(AuthModel.self, from: usableResult)
                            completion(authModel, nil)
                        }catch let error {
                            completion(nil, error)
                        }
                    }
                }
            }
            task.resume()
            
        }
    }
    
    
    func logout (completion: @escaping (Bool) -> Void){
        let logoutURL = URL(string : EndPointURL.auth)
        var request = URLRequest(url: logoutURL!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data ,response , error in
            if error != nil {
                completion(false)
                
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode == 200
                else {
                    completion(false)
                    self.alertMessage(title: "Error", error: "Please, check your network connection")
                    return
            }
            completion(true)
        }
        task.resume()
    }
    
    
    
    func getStudentLocations(completion: @escaping ([LocationModel]?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: EndPointURL.studentLocation)!)
        
        let task = URLSession.shared.dataTask(with: request) {data ,response ,error in
            if error != nil {
                completion(nil, error)
            }else{
                if let data = data {
                    do {
                        let studentLocation = try JSONDecoder().decode(StudentLocation.self, from: data)
                        completion(studentLocation.results, nil)
                    }catch let error {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    func getStudentLocationsLimit(completion: @escaping ([LocationModel]?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: EndPointURL.studentLocationLimit)!)
        
        let task = URLSession.shared.dataTask(with: request) {data ,response ,error in
            if error != nil {
                completion(nil, error)
            }else{
                if let data = data {
                    do {
                        let studentLocation = try JSONDecoder().decode(StudentLocation.self, from: data)
                        completion(studentLocation.results, nil)
                    }catch let error {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }

    
    
    func postStudentLocations(map: String , url: String ,lat: Double , lng:Double , completion: @escaping (Bool) -> Void){
        var request = URLRequest(url: URL(string: EndPointURL.studentLocation)!)
        request.httpMethod = "POST"
      
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String:Any] = [
            "uniqueKey": "1234",
            "firstName": "Mr. ",
            "lastName": "X",
            "mapString": map,
            "mediaURL": url,
            "latitude": lat,
            "longitude": lng
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            alertMessage(title: "Error", error: "Can't access data , try again")
            return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false)
                self.alertMessage(title: "Error", error: "Please, check your network connection")
                return
            }
            completion(true)
        }
        task.resume()
    }
    
    func alertMessage(title: String , error: String ){
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    

    

}
