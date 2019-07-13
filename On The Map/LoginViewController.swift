//
//  ViewController.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    func alertMessage(title: String , error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
    
        
    @IBAction func login(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.alertMessage(title: "Error", error: "Please, enter your E-mail or password")
        } else {
            let apiServece = DataProviderService()
            
            apiServece.authenticate(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (authModel, error) in
                DispatchQueue.main.async {
                    if  error != nil {
                        let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if let authModel = authModel, let isRegestred = authModel.account?.registered  {
                            if isRegestred {
                                // Navegate To Home Screen
                                if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                                    self.present(homeViewController, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: "Oh Sorry!", message: "You seem like not registered yet ", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        let url = URL(string: "ßß")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

