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
    var isArchive: Bool
    var date: Date
    
    init(id: String, title: String, note: String, user: String, isArchive: Bool, date: Date){
        self.id = id
        self.title = title
        self.note = note
        self.user = user
        self.isArchive = isArchive
        self.date = date
    }
    
    var dictionary: [String: Any] {
            return[
            "title": title,
            "note": note,
            "user": user,
            "isArchive": isArchive,
            "date": date
            ]
        }
}
