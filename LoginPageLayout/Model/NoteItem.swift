//
//  NoteItem.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import Foundation
import FirebaseFirestore
import Firebase

struct NoteItem: Codable{
    var id: String
    var title: String
    var note: String
    var user: String
    var date: Date
    
    init(id: String, title: String, note: String, user: String, date: Date){
        self.id = id
        self.title = title
        self.note = note
        self.user = user
        self.date = date
    }
    
    var dictionary: [String: Any] {
            return[
            "title": title,
            "note": note,
            "user": user,
            "date": date
            ]
        }
}
