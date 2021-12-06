//
//  ReminderController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 09/11/21.
//

import Foundation
import UIKit

class ReminderController: UIViewController{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var completion: ((Date)-> Void)?
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveDate(){
        let remindDate = datePicker.date
        completion?(remindDate)
    }
    
    @objc func closePicker() {
        dismiss(animated: true)
    }
    
    //MARK: - Helper functions
    
    func configureUI(){
        
        view.backgroundColor = .systemGray
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Add Reminder"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done,  target: self, action: #selector(saveDate))
        
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 30
    }
}
