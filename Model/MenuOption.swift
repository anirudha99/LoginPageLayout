//
//  MenuOption.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible{
    
    case Profile
    case Archive
    case Reminders
    case Settings
    case Logout
    
    var description: String{
        switch self{
            
        case .Profile:
            return "Profile"
        case .Archive:
            return "Archive"
        case .Reminders:
            return "Reminders"
        case .Settings:
            return "Settings"
        case .Logout:
            return "Logout"
        }
    }
    
    var image: UIImage{
        switch self{
            
        case .Profile:
            return UIImage(named: "person") ?? UIImage()
        case .Archive:
            return UIImage(named: "mail") ?? UIImage()
        case .Reminders:
            return UIImage(named: "menu2") ?? UIImage()
        case .Settings:
            return UIImage(named: "settings") ?? UIImage()
        case .Logout:
            return UIImage(named: "logout") ?? UIImage()
        }
    }
}


