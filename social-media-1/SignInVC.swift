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
import SwiftKeychainWrapper



class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user{
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }3
                
            }
        })

}
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion:{ (user, error) in
                if error == nil {
                    print("HIMI: User Authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("HIMI: Unable to authenticate with Firebase")
                        } else {
                            print ("HIMI Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                })
        }
        
    })

}
}
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainAssignment = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("HIMI: Data Saved to Keychain \("keychainResult")")
        performSegue(withIdentifier: "goToFeed", sender: nil)
   }
    
}
