//
//  ViewController.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/06.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
class SignInVC: UIViewController {
    
    
    @IBOutlet weak var email: CustomTextField!
    
    @IBOutlet weak var password: CustomTextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //segue cant be loaded in viewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: {
            (result, error) in
            if error != nil {
                print("ERROR: Unable to authenticare with facebook \(error)")
            }
            else if result?.isCancelled == true {
                
            }
            else {
                print("MESSAGE: SUCCES")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
            
            
        })
        
    }
    
    func firebaseAuthenticate(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: {
            (user, error) in
            if error != nil {
                print("ERROR: unable to authenticate with firebase")
            }
            else {
                print("MESSAGE: Successfully autenticated with firebase")
                if let user = user {
                    let userData : Dictionary<String, String> = ["provider": credential.provider]
                    self.completeSignin(id: user.uid, userData: userData)
                    
                    
                }
            }
        })
    }

    @IBAction func signinButtonTouched(_ sender: UIButton) {
        if let email = email.text, let pwd = password.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                (user, error) in
                if error == nil {
                    print("MESAGGE: User exists and signed in")
                    if let user = user {
                        let userData : Dictionary<String, String> = ["provider": user.providerID]
                        self.completeSignin(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {
                        (user, error) in
                        if error != nil {
                            print("MESSAGE: UNABLE TO AUTHENTICATE FIREBASE WITH EMAIL")
                        }
                        else {
                            print("SUCCESS: ")
                            if let user = user {
                                let userData : Dictionary<String, String> = ["provider": user.providerID]
                                self.completeSignin(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
                
            })
        }
    }
    
    func completeSignin(id: String, userData: Dictionary<String, String>) {
//        let customKeychainWrapperInstance = KeychainWrapper(serviceName: uniqueServiceName, accessGroup: uniqueAccessGroup)
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "goToFeed", sender: nil)
//        let saveSucceful =  customKeychainWrapperInstance.set(id, forKey: KEY_UID)
    }
}

