//
//  Categories.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import UIKit

struct Category {
    let name:String
    let image:UIImage
    let apiIdentifier:String
    
    static func createCategories() -> [Category]{
        
        let categories = [
            Category(name: "Art", image: #imageLiteral(resourceName: "headphones"), apiIdentifier: "234"),
            Category(name: "Music", image: #imageLiteral(resourceName: "art"), apiIdentifier: "234"),
            Category(name: "Liberal Concerts", image: #imageLiteral(resourceName: "headphones"), apiIdentifier: "234")
        ]
        
        return categories
    }
}


