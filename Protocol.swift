//
//  Protocol.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 25/10/21.
//

import Foundation

protocol HomeViewControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}

protocol RemoveReminderDelegate {
    func removeReminder(note: NoteItem)
}
