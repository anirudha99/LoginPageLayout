//
//  ContainerViewController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 25/10/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ContainerController: UIViewController{
    
    //MARK: - Properties
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    //MARK: - Handlers
    
    
    func configureHomeController(){
        
        let homeController = HomeViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenucontroller(){
        if menuController == nil{
            //add menu contoller here
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            
            print("did add menu controller")
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?){
        
        if shouldExpand{
            //show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        }
        else{
            //hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.centerController.view.frame.origin.x = 0
            } completion: { (_) in
                guard let menuOption = menuOption else {
                    return
                }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption){
        switch menuOption{
            
        case .Profile:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileController") as? ProfileController
            
            guard let ProfileVC = ProfileVC else{
                return
            }
            let presentVc = UINavigationController(rootViewController: ProfileVC)
            presentVc.modalPresentationStyle = .fullScreen
            self.present(presentVc, animated: true, completion: nil)
            
        case .Archive:
            let controller = ArchiveController()
            let presentVc = UINavigationController(rootViewController: controller)
            presentVc.modalPresentationStyle = .fullScreen
            present(presentVc, animated: true, completion: nil)
            
        case .Reminders:
            let controller = DateTimeReminderController()
            let presentVc = UINavigationController(rootViewController: controller)
            presentVc.modalPresentationStyle = .fullScreen
            present(presentVc, animated: true, completion: nil)
            
        case .Settings:
            let controller = SettingsController()
            let presentVc = UINavigationController(rootViewController: controller)
            presentVc.modalPresentationStyle = .fullScreen
            present(presentVc, animated: true, completion: nil)
            
        case .Logout:
            // logout button func
            let result = signOut()
            if result == true{
                self.transitionToMainPage()
                showLogoutAlert()
            }
            else {
                showLogoutErrorAlert()
            }
        }
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func showLogoutAlert(){
        let alertController = UIAlertController(
            title: "Successful! ", message: "Logged out!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(
            title: "OK", style: .default)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showLogoutErrorAlert(){
        let alertController = UIAlertController(
            title: "Error! ", message: "failed to Log out!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ContainerController: HomeViewControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded{
            configureMenucontroller()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
