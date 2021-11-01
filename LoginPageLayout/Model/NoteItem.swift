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
    
    var dictionary: [String: Any] {
            return[
            "title": title,
            "note": note,
            "user": user,
            "date": date
            ]
        }
}
