//
//  ViewController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 18/10/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var facebookButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements(){
        
        //Style the elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleGoogleButton(googleButton)
        Utilities.styleFacebookButton(facebookButton)
    }
    //
    //    let signInConfig = GIDConfiguration.init(clientID: "480556356863-d0jfv8h59vf8dpk5997bhf64cvh7bh83.apps.googleusercontent.com")
    
    @IBAction func googleButton(_ sender: UIButton) {
        signInGoogle()
    }
    
    func signInGoogle(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                showErrorLogInAlert()
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    print(error.localizedDescription)
                    print(authError)
                }
                else {
                    // User is signed in
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func showErrorLogInAlert(){
        let alertController = UIAlertController(
            title: "Error ", message: "Failed to log in with Google", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//extension ViewController: LoginButtonDelegate {
//
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
//            if let error = error {
//                print("Failed to login: \(error.localizedDescription)")
//                return
//            }
//
//            guard let accessToken = AccessToken.current else {
//                print("Failed to get access token")
//                return
//            }
//
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//
//            // Perform login by calling Firebase APIs
//            Auth.auth().signIn(with: credential) { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//
//                    return
//                }else {
//
//                    self.presentLoggedInHomeScreen()
//                }
//            }
//
//        }
//    }
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
//}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            
            let token = result?.token?.tokenString
            
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connection, result, error in
                
                print("\(result)")
                print("=======")
            }
            self.dismiss(animated: true)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
