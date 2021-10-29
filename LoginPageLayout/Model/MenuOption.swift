//
//  MenuOption.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible{
    
    case Profile
    case Inbox
    case Notifications
    case Settings
    case Logout
    
    var description: String{
        switch self{
            
        case .Profile:
            return "Profile"
        case .Inbox:
            return "Inbox"
        case .Notifications:
            return "Notifications"
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
        case .Inbox:
            return UIImage(named: "mail") ?? UIImage()
        case .Notifications:
            return UIImage(named: "menu2") ?? UIImage()
        case .Settings:
            return UIImage(named: "settings") ?? UIImage()
        case .Logout:
            return UIImage(named: "logout") ?? UIImage()
        }
    }
}


