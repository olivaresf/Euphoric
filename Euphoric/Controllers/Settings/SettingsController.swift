//
//  SettingsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

class SettingsController: UIViewController {
    
    var tableView:UITableView!
    var indexPath:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(handleClose))
        navigationItem.rightBarButtonItem?.tintColor = .black
        configureTableView()
    }
    
    @objc func handleClose(){
        dismiss(animated: true, completion: nil)
    }
    
    private func configureTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        view.addSubview(tableView)
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
    }

}

extension SettingsController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Communications:
            return CommunicationsOptions.allCases.count
        case .Social:
            return SocialOptions.allCases.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SettingsCell
//        cell.textLabel?.text = SettingsSection(rawValue: indexPath.section)?.description
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        configureCallback(cell: cell, tableView: tableView)
        
        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
//            cell.textLabel?.text = social?.description
            cell.sectionType = social
            cell.imageView?.image = UIImage(systemName: social?.image ?? "")
            cell.switchControl.tag = indexPath.section
//            if social?.containsSwitch == true{
//                print(indexPath.row, indexPath.section)
//            }
            
        case .Communications:
            let communications = CommunicationsOptions(rawValue: indexPath.row)
//            cell.textLabel?.text = communications?.description
            cell.sectionType = communications
            cell.imageView?.image = UIImage(systemName: communications?.image ?? "")
            cell.switchControl.tag = indexPath.section
//            if communications?.containsSwitch == true{
//                print(indexPath.row, indexPath.section)
//            }

        }
        
        return cell
    }
    
    func configureCallback(cell:SettingsCell, tableView:UITableView){
        
        cell.callback = {currentCell, isOn in
            
//            guard let self = self else {return}
            
            guard let currentIndexPath = tableView.indexPath(for: currentCell) else {return}
            guard let section = SettingsSection(rawValue: currentIndexPath.section) else {return}
            
            switch section {
            case .Social:
                guard let social = SocialOptions(rawValue: currentIndexPath.row) else {return}
                
                if social.description == "Edit profile"{
                    print(isOn)
                }
                
            case .Communications:
                guard let communications = CommunicationsOptions(rawValue: currentIndexPath.row) else {return}
                
                if communications.description == "Notifications"{
                    print(isOn)
                } else if communications.description == "Email"{
                    print(isOn)
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        let currentCell = tableView.cellForRow(at: indexPath) as! SettingsCell
        
        if currentCell.sectionType?.containsSwitch == false{
            pushSettingsControllers(for: section, atRow: indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    private func pushSettingsControllers(for section:SettingsSection, atRow row:Int){
        
        switch section {
        case .Social:
//            let social = SocialOptions(rawValue: row)
            print("xd")
            
        case .Communications:
            let communications = CommunicationsOptions(rawValue: row)
            navigationController?.pushViewController(communications?.viewControllerAssociated ?? UIViewController(), animated: true)
        }
        
    }
    
}
