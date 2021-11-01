//
//  RealmManager.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 31/10/21.
//

import Foundation
import Firebase
import RealmSwift

struct RealmManager {
    
    static var shared = RealmManager()
    
    let realmInstance = try! Realm()
    
    var notesRealm : [NotesItem] = []
    
    func addNote(note:NotesItem){
        try! realmInstance.write({
            realmInstance.add(note)
        })
    }
    
    mutating func deleteNote(index: Int){
        let notesReal = realmInstance.objects(NotesItem.self)
        try! realmInstance.write({
            realmInstance.delete(notesReal[index])
        })
    }
    
//    mutating func deleteNote(index:Int){
////        let notesReal = realmInstance.objects(NotesItem.self)
//        try! realmInstance.write({
//            realmInstance.delete(notesRealm[index])
//        })
//        notesRealm.remove(at:index)
//    }
    
    func updateNote(_ title:String,_ noteContent:String, note:NotesItem){
        let realmInstance = try! Realm()
        try! realmInstance.write({
            note.title = title
            note.note = noteContent
        })
        /* let predicate = NSPredicate.init(format: "%K == %@", title,title)
         let predicateScond = NSPredicate.init(format: "%K == %@", note,note)*/
        
    }
    
    mutating  func fetchNotes(completion :@escaping([NotesItem])->Void) {
        let userid = NetworkManager.shared.getUID()
//        print(userid)
        var notesArray :[NotesItem] = []
//        let notes = realmInstance.objects(NotesItem.self)
        let predicate = NSPredicate.init(format: "%K == %@", "uid",userid!)
        let notes = realmInstance.objects(NotesItem.self).filter(predicate)
        for note in notes
        {
//            notesRealm.append(note)
            notesArray.append(note)
            
        }
        completion(notesArray)
        print(notes)
        
    }
}

