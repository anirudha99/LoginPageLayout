//
//  PersistantManager.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 29/10/21.
//

//import Foundation
//import Realm
//import RealmSwift
//
//struct PersistentManager {
//    static let shared = PersistentManager()
//    
//    let realm = try! Realm()
//    
//    func addNote(note: RealmNote) {
//        try! realm.write {
//            realm.add(note)
//        }
//    }
//    
//    func getNote(completion: @escaping([RealmNote]) -> Void) {
//        var notesArray: [RealmNote] = []
//        
//        let uid = NetworkManager.shared.getUID()!
//        
//        let notes = realm.objects(RealmNote.self).filter("user = '\(uid)'")
//        
//        for note in notes {
//            notesArray.append(note)
//        }
//        completion(notesArray)
//        
//    }
//    
//    func updateNote(note: RealmNote, title: String, description: String) {
//        try! realm.write {
//            note.title = title
//            note.note = description
//        }
//    }
//    
//    func deleteNote(note: RealmNote) {
//        try! realm.write({
//            realm.delete(note)
//        })
//    }
//}
