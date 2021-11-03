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


//class NoteController: UITableViewController
class NoteController: UIViewController, UITextFieldDelegate{
    
    var noteArray: [NoteItem] = []
    
    var isNew: Bool = true
    
    var note: NoteItem?
    var noteRealm :NotesItem?
//    var realmNote: RealmNote?
    
    let realmInstance = try! Realm()
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isNew{
            loadData()
            titleField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            noteField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        }
        //        configureUI()
        //
        //        tableView.register(UITableViewCell.self,
        //                           forCellReuseIdentifier: "Cell")
        navigationItem.title = isNew ? "ADD NOTE" : "EDIT NOTE"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        view.backgroundColor = .darkGray
    }
    
    //MARK: - Selectors
    
    //save new note or update the data
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if titleField.text == "" || noteField.text == "" {
            showAlert(title: "Invalid", message: "Title or Note cannot be Empty")
        } else if isNew {
            let db = Firestore.firestore()
            let newDoc = db.collection("notes").document()
//            let newNote = NoteItem(id: newDoc.documentID, title: titleField.text!,
//                                               note: noteField.text!,
//                                               user: NetworkManager.shared.getUID()!,
//                                               date: Date())
            
            let realmNote = NotesItem()
            realmNote.title = titleField.text!
            realmNote.note = noteField.text!
            realmNote.uid = NetworkManager.shared.getUID()!
            realmNote.date = Date()
            RealmManager.shared.addNote(note: realmNote)
           
            let content: [String: Any] = ["id": newDoc.documentID , "title": titleField.text!, "note": noteField.text!, "user": NetworkManager.shared.getUID()!,"date": Date()]
            
            db.collection("notes").addDocument(data: content)
            dismiss(animated: true)
        } else {
            note?.title = titleField.text!
            note?.note = noteField.text!
            
            NetworkManager.shared.updateData(note: note!)

            dismiss(animated: true)
        }
    }
    
    //checks if textfield is changed
    @objc func textFieldChanged() {
        
        saveButton.isHidden = note?.title != titleField.text ||
        note?.note != noteField.text ? false : true
    }
    
    
    //clear textfields
    @IBAction func discardButtonPressed(_ sender: UIButton) {
        titleField.text = ""
        noteField.text = ""
    }
    
    //    var itemArr: [NSManagedObject] = []
    
    //load note data and show save button if changed
    func loadData(){
        titleField.text = note?.title
        noteField.text = note?.note
        saveButton.setTitle("UPDATE", for: .normal)
        saveButton.isHidden = true
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
        
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Notes"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddNote))
    }
    
}

