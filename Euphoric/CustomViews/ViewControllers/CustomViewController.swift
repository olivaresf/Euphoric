//
//  CustomViewController.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class CustomViewController: UIViewController {
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate var blurEffect = UIBlurEffect()
    fileprivate var blurredEffectView = UIVisualEffectView()
    lazy var titleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    let mainTitle = UITextView()
    
    func setupNavbar(title:String){
        
        let coverWhiteView = UIView()
        coverWhiteView.translatesAutoresizingMaskIntoConstraints = false
        coverWhiteView.backgroundColor = .systemBackground
        view.addSubview(coverWhiteView)
        
        NSLayoutConstraint.activate([
            coverWhiteView.topAnchor.constraint(equalTo: view.topAnchor),
            coverWhiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverWhiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        guard let safeAreaTop = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.top else {return}
        coverWhiteView.heightAnchor.constraint(equalToConstant: safeAreaTop).isActive = true
        
        titleView = UIView()
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        mainTitle.text = title
        mainTitle.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
//        mainTitle.textColor = .systemPink
        mainTitle.backgroundColor = .clear
        titleView.addSubview(mainTitle)
        NSLayoutConstraint.activate([
            mainTitle.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            mainTitle.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            mainTitle.heightAnchor.constraint(equalToConstant: 40),
            mainTitle.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        ])
        
        navigationItem.titleView = titleView
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        gradientLayer.frame = view.bounds
    }
    
}

