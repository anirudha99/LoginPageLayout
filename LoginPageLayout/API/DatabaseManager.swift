//
//  DatabaseManager.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 07/11/21.
//

import Foundation
import UIKit
import RealmSwift

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    func updateNote(note:NoteItem , realmNote:NotesItem, title:String, content:String)
    {
        NetworkManager.shared.updateData(note: note)
        RealmManager.shared.updateNote(title,content,note: realmNote)
        //        RealmManager.shared.updateNote(title, content,realmNote)
    }
    
    func addNote(note : [String:Any], realmNote : NotesItem)
    {
        NetworkManager.shared.addNote(note: note)
        RealmManager.shared.addNote(note: realmNote)
    }
    
    
    func deleteNote(deleteNoteId : String, deleteRealNote : NotesItem){
        NetworkManager.shared.deleteNote(deleteNoteId)
        RealmManager.shared.deleteNote(note: deleteRealNote)
    }
    
    //
    //        NetworkManager.shared.deleteData(note: NoteItem )
    //        RealmManager.shared.deleteNote(index: )
    //        NetworkManager.shared.deleteNote(noteId)
    //        RealmManager.shared.deleteNote(note: note)
    
    
}
