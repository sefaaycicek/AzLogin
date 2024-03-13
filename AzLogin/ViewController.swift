//
//  ViewController.swift
//  AzLogin
//
//  Created by Sefa Aycicek on 13.03.2024.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FacebookLogin
import GoogleSignIn

class ViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveUser(_ sender: Any) {
        guard let userName = txtName.text, let password = txtPassword.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: userName, password: password) { result, error in
            if error != nil {
                
            }
        }
        
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // Buraya kadarki kısım GoogleSign'in sdk'sından google ile login olma süreci
            // Aşağıdaki Auth -> Firebase üzerine kullanıcıyı login yapmak için
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    //success login
                }
            }
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { loginResult, error in
            if let token = loginResult?.token?.tokenString {
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if error != nil {
                        //success login
                    }
                }
            }
        }
    }
}

