//
//  NoteController.swift
//  SideMenu
//
//  Created by Anirudha SM on 26/10/21.
//

import Foundation
import UIKit
import CoreData
import FirebaseFirestore
import FirebaseCore
import Firebase


//class NoteController: UITableViewController
class NoteController: UIViewController, UITextFieldDelegate{
    
    var noteArray: [NoteItem] = []
    
    var isNew: Bool = true
    
    var note: NoteItem?
    
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
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        guard let appDelegate =
    //          UIApplication.shared.delegate as? AppDelegate else {
    //            return
    //        }
    //
    //        let managedContext =
    //          appDelegate.persistentContainer.viewContext
    //
    //        let fetchRequest =
    //          NSFetchRequest<NSManagedObject>(entityName: "Items")
    //
    //        do {
    //          itemArr = try managedContext.fetch(fetchRequest)
    //        } catch let error as NSError {
    //          print("Could not fetch. \(error), \(error.userInfo)")
    //        }
    //    }
    
    //MARK: - Selectors
    
    //save new note or update the data
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if titleField.text == "" || noteField.text == "" {
            showAlert(title: "Invalid", message: "Title or Note cannot be Empty")
        } else if isNew {
            let db = Firestore.firestore()
            let newDoc = db.collection("notes").document()
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
    
    @objc func handleAddNote() {
        //        let alert = UIAlertController(title: "New Note",
        //                                      message: "Add a new note",
        //                                      preferredStyle: .alert)
        //        let saveAction = UIAlertAction(title: "Save", style: .default) {
        //            [unowned self] action in
        //            guard let textField = alert.textFields?.first,
        //                  let noteToSave = textField.text else {
        //                      return
        //                  }
        //            self.save(item: noteToSave)
        //            self.tableView.reloadData()
        //          }
        //        let cancelAction = UIAlertAction(title: "Cancel",
        //                                         style: .cancel)
        //
        //        alert.addTextField()
        //
        //        alert.addAction(saveAction)
        //        alert.addAction(cancelAction)
        //
        //        present(alert, animated: true)
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
    
    //    func save(item:String){
    //        guard let appDelegate =
    //          UIApplication.shared.delegate as? AppDelegate else {
    //          return
    //        }
    //
    //        let managedContext =
    //          appDelegate.persistentContainer.viewContext
    //
    //        let entity =
    //          NSEntityDescription.entity(forEntityName: "Items",
    //                                     in: managedContext)!
    //
    //        let title = NSManagedObject(entity: entity,
    //                                     insertInto: managedContext)
    //
    //        title.setValue(item, forKeyPath: "item")
    //
    //        do {
    //          try managedContext.save()
    //            itemArr.append(title)
    //        } catch let error as NSError {
    //          print("Could not save. \(error), \(error.userInfo)")
    //        }
    //    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return itemArr.count
    //    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let item = itemArr[indexPath.row]
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    //        cell.textLabel?.text =
    //          item.value(forKeyPath: "item") as? String
    //        return cell
    //    }
    
}

