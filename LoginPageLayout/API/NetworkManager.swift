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
    
    func getData(completion: @escaping([NoteItem])-> Void){

        guard let uid = NetworkManager.shared.getUID() else { return }
        
        db.collection("notes").getDocuments { (snapshot, error) in
            
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
                completion(notes)
            }
        }
    }
    
    func deleteData(note: NoteItem) {
        db.collection("notes").document(note.id).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateData(note: NoteItem){
        db.collection("notes").document(note.id).updateData(["title": note.title, "note": note.note]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

