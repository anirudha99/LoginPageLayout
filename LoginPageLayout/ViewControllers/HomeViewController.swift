//
//  HomeViewController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 19/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        
        let result = signOut()
        if result == true{
            showLogoutAlert()
        }
        else {
            showLogoutErrorAlert()
        }
    }
    
    
    func signOut() -> Bool{
        
        do {
            let firebaseAuth = Auth.auth()
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
            let manager = LoginManager()
            manager.logOut()
            return true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return false
        }
    }
    
    func showLogoutAlert(){
        let alertController = UIAlertController(
            title: "Successful! ", message: "Logged out!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(
            title: "OK", style: .default, handler: {(action) in
                self.transitionToMainPage()})
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showLogoutErrorAlert(){
        let alertController = UIAlertController(
            title: "Successful! ", message: "Logged out!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func transitionToMainPage(){
        
        let rootViewC = storyboard?.instantiateViewController(withIdentifier: "rootViewController") as? ViewController
        
        view.window?.rootViewController = rootViewC
        view.window?.makeKeyAndVisible()
        
    }
}
