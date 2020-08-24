//
//  SettingsCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    var sectionType:SectionType?{
        didSet{
            guard let sectionType = sectionType else {return}
            
            textLabel?.text = sectionType.description
            
            switchControl.isHidden = !sectionType.containsSwitch
            
            selectionStyle = !sectionType.containsSwitch ? .default : .none
            accessoryType = !sectionType.containsSwitch ? .disclosureIndicator : .none
        }
    }
    
    lazy var switchControl:UISwitch = {
        let userDefaults = UserDefaults.standard
        let color = userDefaults.string(forKey: "tintColor") ?? ""
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = userDefaults.colorForKey(key: "tintColor") ?? .systemPink
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        return switchControl
    }()
    
    var callback : ((UITableViewCell, Bool) -> Void)?
    
    @objc func handleSwitch(sender:UISwitch){
        callback?(self, sender.isOn)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tertiarySystemBackground
        tintColor = .normalDark
        textLabel?.textColor = UIColor(named: "primaryLabel")
        
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
