//
//  ViewController.swift
//  CherryPick
//
//  Created by Jasmine Jahan on 5/4/22.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    
    var registerOption = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let emailId = email.text{
            if let pass = password.text{
                if registerOption{
                    Auth.auth().createUser(withEmail: emailId, password: pass) { authResult, error in
                        guard let user = authResult?.user, error == nil else {
                            self.presentAlert(alert: error!.localizedDescription)
                            // print(error!.localizedDescription)
                            return
                        }
                        //print("Signup OK")
                        self.performSegue(withIdentifier: "ToMapViewController", sender: nil)
                    }
                }else{
                    Auth.auth().signIn(withEmail: emailId, password: pass) { authResult, error in
                        guard let user = authResult?.user, error == nil else {
                            self.presentAlert(alert: error!.localizedDescription)
                            return
                        }
                        //print("Login OK")
                        self.performSegue(withIdentifier: "ToMapViewController", sender: nil)
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    func presentAlert(alert: String){
        let errorVC = UIAlertController(title: "Alert", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            errorVC.dismiss(animated: true, completion: nil)
        }
        errorVC.addAction(okAction)
        present(errorVC, animated: true, completion: nil)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        if registerOption{
            registerOption = false
            login.setTitle("Log In", for: .normal)
            register.setTitle("New Player Register", for: .normal)
        }else{
            registerOption = true
            register.setTitle("Exsisting Player LogIn", for: .normal)
            login.setTitle("SignUp", for: .normal)
        }
    }
}

