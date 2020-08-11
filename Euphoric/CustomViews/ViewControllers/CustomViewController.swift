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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurGradient()
    }
    
    fileprivate func setupBlurGradient(){
        gradientLayer.colors = [UIColor.topColor.cgColor, UIColor.middleColor.cgColor, UIColor.bottomColor.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.opacity = 1
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
        
        
        blurEffect = UIBlurEffect(style: .extraLight)
        
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 1
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
}

