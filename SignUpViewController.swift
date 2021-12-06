//
//  SignUpViewController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 19/10/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func  setUpElements(){
        
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    //Check the fields and validate that data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String?{
        
        //Check all the fields are checked in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        //Check if password is valid
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPassword) == false {
            //Password isn't valid
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        signIn()
    }
    
    func signIn(){
        //validate the fields
        let error = validateFields()
        if error != nil {
            //There is something wrong with the fields, show error message
            showError(error!)
        }
        else{
            //Create cleaned versions of data
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //Check for errors
                if let err = err {
                    //There is an error crerating the user
                    self.showError("Error creating user")
                }
                else{
                    //User created successfully, now store the first name  and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstname, "lastname":lastname,"uid":result!.user.uid ]) { (error) in
                        if error != nil{
                            //show error message
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to the home screen by dismissing the screen
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
