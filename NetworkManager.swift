//
//  NetworkManager.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 26/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FirebaseFirestore
import CoreMedia
import Firebase

//Logout function
public func signOut() -> Bool{
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

var fetchingMoreNotes = false

var lastDocument: QueryDocumentSnapshot?

struct NetworkManager {
    let db = Firestore.firestore()
    
    static let shared = NetworkManager()
    
    //Login function
    func login(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
    //Sign Up function
    func signup(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    //Get UID
    func getUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    //Add note to the database
    func addNote(note: [String: Any]) {
        db.collection("notes").addDocument(data: note)
    }
    
    //Delete note from the database
    func deleteNote(_ noteId:String) {
        db.collection("notes").document(noteId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //Update note
    func updateData(note: NoteItem){
        db.collection("notes").document(note.id).updateData(note.dictionary) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //Downloading image with url
    func downloadImage(fromURL urlString: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
    
    //Fetching notes for pagination
    func fetchMoreNotesData(completion: @escaping([NoteItem]) -> Void){
        fetchingMoreNotes = true
        guard let lastNoteDocument = lastDocument else { return }
        db.collection("notes").order(by: "date").start(afterDocument: lastNoteDocument).limit(to: 8).getDocuments { snapshot, error in
            
            var notes: [NoteItem] = []
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if snapshot != nil {
                for document in snapshot!.documents {
                    let noteData = document.data()
                    let id = document.documentID
                    let title = noteData["title"] as? String ?? ""
                    let note = noteData["note"] as? String ?? ""
                    let user = noteData["user"] as? String ?? ""
                    let isArchive = noteData["isArchive"] as? Bool ?? false
                    let date = (noteData["date"] as? Timestamp)?.dateValue() ?? Date()
                    
                    notes.append(NoteItem(id: id, title: title, note: note, user: user, isArchive: isArchive, date: date))
                }
                lastDocument = snapshot!.documents.last
                fetchingMoreNotes = false
                completion(notes)
            }
        }
    }
    
    //Generic function to get archived notes
    func resultType(archivedNotes: Bool,completion: @escaping(Result<[NoteItem], Error>) -> Void) {
        
        guard let uid = NetworkManager.shared.getUID() else { return }
        
        db.collection("notes").whereField("user", isEqualTo: uid).whereField("isArchive", isEqualTo: archivedNotes).limit(to: 8).getDocuments { snapshot, error in
            var notes: [NoteItem] = []
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            
            for doc in snapshot.documents {
                let data = doc.data()
                let id = doc.documentID
                let title = data["title"] as? String ?? ""
                let note = data["note"] as? String ?? ""
                let user = data["user"] as? String ?? ""
                let isArchive = data["isArchive"] as? Bool ?? false
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                
                let newNote = NoteItem(id: id, title: title, note: note, user: user, isArchive: isArchive, date: date)
                notes.append(newNote)
            }
            lastDocument = snapshot.documents.last
            completion(.success(notes))
        }
    }
    
    //Generic function to get reminder notes
    func fetchReminderNotes(completion: @escaping(Result<[NoteItem], Error>) -> Void) {
        guard let uid = NetworkManager.shared.getUID() else { return }
        
        let nilValue: Date? = nil
        
        db.collection("notes").whereField("user", isEqualTo: uid).whereField("reminder", isNotEqualTo: nilValue).limit(to: 8).getDocuments { snapshot, error in
            var notes: [NoteItem] = []
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            
            for doc in snapshot.documents {
                let data = doc.data()
                let id = doc.documentID
                let title = data["title"] as? String ?? ""
                let note = data["note"] as? String ?? ""
                let user = data["user"] as? String ?? ""
                let isArchive = data["isArchive"] as? Bool ?? false
                let reminder = (data["reminder"] as? Timestamp)?.dateValue() ?? Date()
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                
                let newNote = NoteItem(id: id, title: title, note: note, user: user, isArchive: isArchive,reminder: reminder, date: date)
                notes.append(newNote)
            }
            lastDocument = snapshot.documents.last
            completion(.success(notes))
        }
    }
}

