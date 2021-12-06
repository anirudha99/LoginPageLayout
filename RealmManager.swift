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
    
    
    //Add note to realm
    public func addNote(note:NotesItem){
        try! realmInstance.write({
            realmInstance.add(note)
        })
    }
    
    //Delete note from realm
    mutating func deleteNote(note: NotesItem){
        try! realmInstance.write({
            realmInstance.delete(note)
        })
    }
    
    //Updating realm notes
    public func updateNote(_ title:String,_ noteContent:String, note:NotesItem){
        let realmInstance = try! Realm()
        try! realmInstance.write({
            note.title = title
            note.note = noteContent
        })
    }
    
    //Fetch notes from Realm
    mutating func fetchNotes(completion :@escaping([NotesItem])->Void) {
        let userid = NetworkManager.shared.getUID()
        var notesArray :[NotesItem] = []
        let predicate = NSPredicate.init(format: "%K == %@", "uid",userid!)
        let notes = realmInstance.objects(NotesItem.self).filter(predicate)
        for note in notes
        {
            notesArray.append(note)
        }
        completion(notesArray)
        print(notes)
    }
  
}

