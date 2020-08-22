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
    case Social
    
    var description:String{
        switch self {
        case .LookFeel:
            return "Look & Feel"
        case .Social:
            return "Social"
        }
    }

}


enum LookFeelOptions:Int,CaseIterable, SectionType{
    case theme
    case appTint
    case reduceMotion
    
    var description:String{
        switch self {
        case .theme:
            return "Theme"
        case .appTint:
            return "App Tint"
        case .reduceMotion:
            return "Reduce Motion"
        }
    }
    
    var icon:String{
        switch self {
        case .theme:
            return "paintpalette"
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
        case .theme:
            return UIViewController()
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


enum SocialOptions:Int, CaseIterable, SectionType {
    
    case support
    
    var containsSwitch:Bool{ return false }
    
    var containsDisclosure:Bool{return true}
    
    var description: String{ return "Support the Creator 💙"}
    
    var icon:String{ return "Support"}
    
    var viewControllerAssociated: UIViewController{return UIViewController()}
}
