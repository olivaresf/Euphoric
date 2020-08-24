//
//  SettingsSection.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

protocol SectionType:CustomStringConvertible {
    var containsSwitch:Bool{ get }
    var containsDisclosure:Bool{ get }
}

enum SettingsSection:Int, CaseIterable, CustomStringConvertible {
    
    case LookFeel
    case Player
    case Social
    
    var description:String{
        switch self {
        case .LookFeel:
            return "Look & Feel"
        case .Player:
            return "Player"
        case .Social:
            return "Social"
        }
    }

}


enum LookFeelOptions:Int,CaseIterable, SectionType{
//    case theme
    case appTint
    case reduceMotion
    
    var description:String{
        switch self {
//        case .theme:
//            return "Theme"
        case .appTint:
            return "App Tint"
        case .reduceMotion:
            return "Reduce Motion"
        }
    }
    
    var icon:String{
        switch self {
//        case .theme:
//            return "paintpalette"
        case .appTint:
            return "paintbrush"
        case .reduceMotion:
            return "wind"
        }
    }
    
    var viewControllerAssociated:UIViewController{
        switch self {
        case .appTint:
            return AppTintController(collectionViewLayout: UICollectionViewFlowLayout())
//        case .theme:
//            return UIViewController()
        case .reduceMotion:
            return UIViewController()
        }
    }
    
    var containsDisclosure:Bool{
        switch self {
        case .reduceMotion:
            return false
        default:
            return true
        }
    }
    
    var containsSwitch:Bool{
        switch self {
        case .reduceMotion:
            return true
        default:
            return false
        }
    }
    
}

enum PlayerOptions:Int, CaseIterable, SectionType{

    case resetFavorites
    
    var description: String{return "Reset Favorites"}
    
    var containsSwitch: Bool{ return false }
    
    var containsDisclosure: Bool{ return true }
    
    var icon:String{return "xmark"}
    
}


enum SocialOptions:Int, CaseIterable, SectionType {
    
    case support
    case rate
    case euphoric
    
    
    var containsSwitch:Bool{ return false }
    
    var containsDisclosure:Bool{return true}
    
    var description: String{
        switch self {
        case .euphoric:
            return "Euphoric 1.0"
        case .rate:
            return "Rate on the AppStore"
        case .support:
            return "Support the Creator"
        }
    }
    
    var icon:String{
        switch self {
        case .euphoric:
            return "euphoric"
        case .rate:
            return "star"
        case .support:
            return "heart.fill"
    }}
    
    var viewControllerAssociated: UIViewController{return UIViewController()}
}
