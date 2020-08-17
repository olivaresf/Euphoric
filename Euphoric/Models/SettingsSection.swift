//
//  SettingsSection.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

protocol SectionType:CustomStringConvertible {
    var containsSwitch:Bool{ get }
//    var containsDisclosure:Bool{ get }
}

enum SettingsSection:Int, CaseIterable, CustomStringConvertible {
    case Social
    case Communications
    
    var description: String{
        switch self {
        case .Social:
            return "Social"
        case .Communications:
            return "Communications"
        }
    }
}

enum SocialOptions:Int, CaseIterable, SectionType {
    case editProfile
    case logout
    
    var containsSwitch:Bool{
        switch self {
        case .editProfile:
            return true
        case .logout:
            return false
        }
    }
    
//    var containsDisclosure:Bool{
//        switch self {
//        case .editProfile:
//            return false
//        case .logout:
//            return true
//        }
//    }
    
    var description: String{
        switch self {
        case .editProfile:
            return "Edit profile"
        case .logout:
            return "Logout"
        }
    }
    
    var image:String{
        switch self {
        case .editProfile:
            return "person"
        case .logout:
            return "scribble"
        }
    }

}

enum CommunicationsOptions:Int, CaseIterable, SectionType {
    case notifications
    case email
    case reportCrashes
    
    var containsSwitch:Bool{
        switch self {
        case .notifications:
            return true
        case .email:
            return true
            
        case .reportCrashes:
            return false
        }
    }
    
//    var containsDisclosure:Bool{
//        switch self {
//        case .notifications:
//            return false
//        case .email:
//            return false
//        case .reportCrashes:
//            return true
//        }
//    }
    
    var description: String{
        switch self {
        case .notifications:
            return "Notifications"
        case .email:
            return "Email"
        case .reportCrashes:
            return "Report Crashes"
        }
    }
    
    var image:String{
        switch self {
        case .notifications:
            return "bell"
        case .email:
            return "tray"
        case .reportCrashes:
            return "pencil"
        }
    }
    
    var viewControllerAssociated: UIViewController{
        switch self {
        case .notifications:
            return UIViewController()
        case .email:
            return UIViewController()
        case .reportCrashes:
//            let vc = CrashesViewController()
            return UIViewController()
        }
    }
}


