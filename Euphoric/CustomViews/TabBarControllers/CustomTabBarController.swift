//
//  CustomTabBarController.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createNavController(for: SearchController(), title: "Search")]
//        tabBar.tintColor = .systemBlue
//        tabBar.barTintColor = .white
//        tabBar.isTranslucent = true
    }
    
    func createNavController(for vc:UIViewController, title:String) -> UINavigationController{
        
        let navController = UINavigationController(rootViewController: vc)
//        navController.title = title
        navController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return navController
        
    }
    
}
