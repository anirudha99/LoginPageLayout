//
//  ViewController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 18/10/21.
//

import UIKit
import AVKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var facebookButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
        checkUserAlreadyLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Set up video in background
        //        setUpVideo()
        
    }
    
    func setUpElements(){
        
        //Style the elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleGoogleButton(googleButton)
        Utilities.styleFacebookButton(facebookButton)
    }
    
    let signInConfig = GIDConfiguration.init(clientID: "480556356863-d0jfv8h59vf8dpk5997bhf64cvh7bh83.apps.googleusercontent.com")
    
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
//                    let emailAddress = user?.profile?.email
//                    let fullName = user?.profile?.name
//                    let givenName = user?.profile?.givenName
                    
                   presentLoggedInHomeScreen()
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
    
    func checkUserAlreadyLoggedIn(){
        //Previous sign in
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil || user != nil {
                // Show the app's signed-in state.
                self.presentLoggedInHomeScreen()
            }
            else {
                return
            }
        }
        
        if let token = AccessToken.current,
           !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            self.presentLoggedInHomeScreen()
        }
        else{
            
            facebookButton.permissions = ["public_profile", "email"]
            facebookButton.delegate = self
        }
    }
    
    func presentLoggedInHomeScreen(){
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    //    func setUpVideo(){
    //
    //        //Get the path to the resource in the bundle
    //        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
    //
    //        guard bundlePath != nil else{
    //            return
    //        }
    //
    //        //Create a URL from it
    //        let url = URL(fileURLWithPath: bundlePath!)
    //
    //        //Create the video player item
    //        let item = AVPlayerItem(url: url)
    //
    //        //Create the player
    //        videoPlayer = AVPlayer(playerItem: item)
    //
    //        //Create the layer
    //        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
    //
    //        //Adjust the size and frame
    //        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
    //
    //        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
    //
    //        //Add it or play it
    //        videoPlayer?.playImmediately(atRate: 0.3)
    //    }
    
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { connection, result, error in
            
            print("\(result)")
        }
        self.presentLoggedInHomeScreen()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}

