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
var fetchingMoreNotes = false

var lastDocument: QueryDocumentSnapshot?

struct NetworkManager {
    let db = Firestore.firestore()
    
    static let shared = NetworkManager()
    func login(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
    func signup(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func getUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func addNote(note: [String: Any]) {
        db.collection("notes").addDocument(data: note)
    }
    
    //    func writeDB(documentName: String, data: [String: Any]) {
    //        let db = Firestore.firestore()
    //
    //        db.collection(documentName).document(getUID()!).setData(data)
    //    }
    //
    //    func readDB(documentName: String) {
    //           let db = Firestore.firestore()
    //           let docRef = db.collection(documentName).document(getUID() ?? "none")
    //
    //           docRef.getDocument { (document, error) in
    //               if let document = document, document.exists {
    //                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    //                   print("Document data: \(dataDescription)")
    //
    //               } else {
    //                   print("Document does not exist")
    //               }
    //           }
    //       }
    
    //    func getData(completion: @escaping([NoteItem])-> Void){
    //
    //        guard let uid = NetworkManager.shared.getUID() else { return }
    //
    //        db.collection("notes").getDocuments { (snapshot, error) in
    //
    //            var notes: [NoteItem] = []
    //
    //            if let error = error {
    //                print(error.localizedDescription)
    //                return
    //            }
    //            if snapshot != nil {
    //                for document in snapshot!.documents {
    //                    let noteData = document.data()
    //                    let id = document.documentID
    //                    let title = noteData["title"] as? String ?? ""
    //                    let note = noteData["note"] as? String ?? ""
    //                    let user = noteData["user"] as? String ?? ""
    //                    let date = (noteData["date"] as? Timestamp)?.dateValue() ?? Date()
    //
    //                    notes.append(NoteItem(id: id, title: title, note: note, user: user, date: date))
    //                }
    //                completion(notes)
    //            }
    //        }
    //    }
    
//    func deleteData(note: NoteItem) {
//        db.collection("notes").document(note.id).delete { error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//    }
    func deleteNote(_ noteId:String) {
        db.collection("notes").document(noteId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          }
        }
      }
    
//    func deleteData(noteId)
    
    func updateData(note: NoteItem){
        db.collection("notes").document(note.id).updateData(["title": note.title, "note": note.note]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    func fetchNoteData(completion: @escaping([NoteItem]) -> Void){
        
        guard let uid = NetworkManager.shared.getUID() else { return }
        
        db.collection("notes").order(by: "date").limit(to: 8).getDocuments { snapshot, error in
            
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
                    let date = (noteData["date"] as? Timestamp)?.dateValue() ?? Date()
                    
                    notes.append(NoteItem(id: id, title: title, note: note, user: user, date: date))
                }
                lastDocument = snapshot!.documents.last
                completion(notes)
            }
        }
    }
    
    func fetchMoreNotesData(completion: @escaping([NoteItem]) -> Void){
        print("*************************33333333333333333")
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
                    let date = (noteData["date"] as? Timestamp)?.dateValue() ?? Date()
                    
                    notes.append(NoteItem(id: id, title: title, note: note, user: user, date: date))
                }
                lastDocument = snapshot!.documents.last
                print(notes)
                print("555555555555555------5555555")
                fetchingMoreNotes = false
                completion(notes)
            }
        }
    }
    
    func resultType(completion: @escaping(Result<[NoteItem], Error>) -> Void) {
            
            guard let uid = NetworkManager.shared.getUID() else { return }
            
            db.collection("notes").whereField("user", isEqualTo: uid).limit(to: 10).getDocuments { snapshot, error in
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
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    
                    let newNote = NoteItem(id: id, title: title, note: note, user: user, date: date)
                    notes.append(newNote)
                }
                lastDocument = snapshot.documents.last
    //            completion(notes, nil)
                completion(.success(notes))
            }
        }
}

