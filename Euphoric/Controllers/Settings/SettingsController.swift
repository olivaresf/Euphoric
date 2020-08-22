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
    var defaults:UserDefaults!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
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
        case .LookFeel:
            return LookFeelOptions.allCases.count
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
        case .LookFeel:
            let lookFeel = LookFeelOptions(rawValue: indexPath.row)
            cell.sectionType = lookFeel
            cell.imageView?.image = UIImage(systemName: lookFeel?.icon ?? "")
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
            cell.imageView?.image = UIImage(systemName: social?.icon ?? "")
        }
        

//        switch section {
//        case .Social:
//            let social = SocialOptions(rawValue: indexPath.row)
//            cell.sectionType = social
//            cell.imageView?.image = UIImage(systemName: social?.image ?? "")
//            cell.switchControl.tag = indexPath.section
////            if social?.containsSwitch == true{
////                print(indexPath.row, indexPath.section)
////            }
//
//        case .Communications:
//            let communications = CommunicationsOptions(rawValue: indexPath.row)
//            cell.sectionType = communications
//            cell.imageView?.image = UIImage(systemName: communications?.image ?? "")
//            cell.switchControl.tag = indexPath.section
////            if communications?.containsSwitch == true{
////                print(indexPath.row, indexPath.section)
////            }
//
//        }

        return cell
    }

    func configureCallback(cell:SettingsCell, tableView:UITableView){

        cell.callback = {currentCell, isOn in

            guard let currentIndexPath = tableView.indexPath(for: currentCell) else {return}
            guard let section = SettingsSection(rawValue: currentIndexPath.section) else {return}
            
            switch section {
            case .LookFeel:
                guard let loofFeel = LookFeelOptions(rawValue: currentIndexPath.row) else {return}
                if loofFeel.description == "Reduce Motion"{
                    print(isOn)
                }
                
            default: return
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
        case .LookFeel:
            let lookFeel = LookFeelOptions(rawValue: row)
            switch lookFeel?.description {
            case "Theme":
                defaults.setColor(color: .systemRed, forKey: "tintColor")
            case "App Tint":
                let lookFeel = LookFeelOptions(rawValue: row)
                navigationController?.pushViewController(lookFeel?.viewControllerAssociated ?? UIViewController(), animated: true)
            default: return
            }

        case .Social:
            let social = SocialOptions(rawValue: row)
            navigationController?.pushViewController(social?.viewControllerAssociated ?? UIViewController(), animated: true)
        }

    }

}
