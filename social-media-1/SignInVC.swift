//
//  ViewController.swift
//  social-media-1
//
//  Created by Gopal Bhojwani on 7/8/17.
//  Copyright © 2017 Hemanshu Bhojwani. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("HIMI: Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true{
                print("HIMI: User cancelled Facebook Authentication")
            } else {
                print("HIMI: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
        
    }
    
    func firebaseAuthenticate(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("HIMI: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("HIMI: Successfully authenticated with Firebase")
            }
        })

}
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion:{ (user, error) in
                if error == nil {
                    print("HIMI: User Authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("HIMI: Unable to authenticate with Firebase")
                        } else {
                            print ("HIMI Successfully authenticated with Firebase")
                        }
                })
        }
        
    })

}
}
}
