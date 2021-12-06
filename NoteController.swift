//
//  NoteController.swift
//  SideMenu
//
//  Created by Anirudha SM on 26/10/21.
//

import UIKit
import CoreData
import FirebaseFirestore
import FirebaseCore
import Firebase
import RealmSwift
import UserNotifications

class NoteController: UIViewController, UITextFieldDelegate{
    
    var noteArray: [NoteItem] = []
    
    var isNew: Bool = true
    
    var note: NoteItem?
    
    var noteRealm :NotesItem?
    
    var remindTime: Date? = nil
    
    let realmInstance = try! Realm()
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreenUI()
        
        if !isNew{
            configureUI()
            loadData()
        }
        else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Image.remind, style: .plain, target: self, action: #selector(navigatePicker))
        }
        
    }
    
    //MARK: - Selectors
    
    //save new note or update the data
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if titleField.text == "" || noteField.text == "" {
            showAlert(title: "Invalid", message: "Title or Note cannot be Empty")
        } else if isNew {
            let db = Firestore.firestore()
            let newDoc = db.collection("notes").document()
            
            let realmNote = NotesItem()
            realmNote.title = titleField.text!
            realmNote.note = noteField.text!
            realmNote.uid = NetworkManager.shared.getUID()!
            realmNote.date = Date()
            RealmManager.shared.addNote(note: realmNote)
            
            let content: [String: Any] = ["id": newDoc.documentID , "title": titleField.text!, "note": noteField.text!, "user": NetworkManager.shared.getUID()!, "isArchive": false, "reminder": remindTime, "date": Date()]
            
            accessNotification()
            NetworkManager.shared.addNote(note: content)
            dismiss(animated: true)
        } else {
            note?.title = titleField.text!
            note?.note = noteField.text!
            note?.reminder = remindTime!
            accessNotification()
            NetworkManager.shared.updateData(note: note!)
            dismiss(animated: true)
        }
    }
    
    @objc func archiveNote(_ sender: UIButton){
        print("Archieve button pressed!!!")
        note!.isArchive = !note!.isArchive
        NetworkManager.shared.updateData(note: note!)
        dismiss(animated: true)
        
    }
    
    @objc func navigatePicker(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let pickerVC = (storyboard.instantiateViewController(withIdentifier: "ReminderController")) as? ReminderController
        else{
            return
        }
        print("REMINDER VC ENTERED")
        pickerVC.completion = { remindDate in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                //                self.dismiss(animated: true)
                self.remindTime = remindDate
            }
        }
        navigationController?.pushViewController(pickerVC, animated: true)
    }
    
    
    func accessNotification(){
        
        guard let remindTime = remindTime else  { return }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.setNotification(remindDate: remindTime)
            } else {
                self.showAlert(title: "Failed", message: "Failed to access Notification")
            }
        }
    }
    
    func setNotification(remindDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Note Remainder for \(titleField.text!)"
        content.sound = .default
        content.body = noteField.text!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: remindDate), repeats: false)
        let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                self.showAlert(title: "Failed", message: "Error")
            }
        }
    }
    
    //clear textfields
    @IBAction func discardButtonPressed(_ sender: UIButton) {
        titleField.text = ""
        noteField.text = ""
    }
    
    //load note data and show save button if changed
    func loadData(){
        titleField.text = note?.title
        noteField.text = note?.note
        remindTime = note?.reminder
        saveButton.setTitle("UPDATE", for: .normal)
        //        saveButton.isHidden = true
    }
    
    //dismiss the screen
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func printNotes(){
        
        let notes = realmInstance.objects(NotesItem.self)
        for note in notes
        {
            print(note)
        }
    }
    
    @objc func handleAddNote() {
        
    }
    
    //MARK: - Helper functions
    
    func configureUI(){
        view.backgroundColor = .systemGray
        navigationItem.title = isNew ? "ADD NOTE" : "EDIT NOTE"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        let archiveButton = UIBarButtonItem(image: note?.isArchive ?? false ?  Constants.Image.unarchive : Constants.Image.archive, style: .plain, target: self, action: #selector(archiveNote))
        
        let remindButton = UIBarButtonItem(image: Constants.Image.remind, style: .plain, target: self, action: #selector(navigatePicker))
        navigationItem.rightBarButtonItems = [archiveButton, remindButton]
        
        view.backgroundColor = .darkGray
    }
}

