//
//  PlayerDetailsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 14/08/20.
//

import UIKit
import AVKit

class PlayerDetailsController: UIViewController {
    
    var episode:Episode!{
        didSet{
            episodeTitle.text = episode.title
            podcastImage.sd_setImage(with: URL(string: episode.imageUrl ?? ""))
            playEpisode()
        }
    }
    
    fileprivate func playEpisode(){
        print(episode.streamUrl)
    }
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) - 60
    }

    let podcastImage = RoundedImageView(image: #imageLiteral(resourceName: "person"))
    
    let trackSlider:UISlider = {
        let slider = UISlider()
        slider.backgroundColor = .clear
        slider.tintColor = .systemPink
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let episodeTitle = TitleLabel(title: "This is a very interesting episode that goes deep in the progre culture", size: 16)
    
    let startTimeLabel:UILabel  = {
        let label = UILabel()
        label.text = "00:00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let finishTimeLabel:UILabel  = {
        let label = UILabel()
        label.text = "00:00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    

    let goForwardButton:UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(systemName: "goforward.30")
        btn.setImage(image, for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemPink
        return btn
        
    }()
    
    let playButton:UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(systemName: "play.fill")
        btn.setImage(image, for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .fill
//        btn.backgroundColor = .black
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
//        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    func setupBackground(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }

                }, completion: nil)
            
        }
    }
    
    fileprivate func setupViews(){
        playButton.constrainWidth(21)
        goForwardButton.constrainWidth(28)
        let topStackView = UIStackView(arrangedSubviews: [episodeTitle, playButton, goForwardButton])
        topStackView.axis = .horizontal
        topStackView.distribution = .fill
        topStackView.alignment = .fill
        topStackView.spacing = 18
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topStackView)
        topStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 22, bottom: 0, right: 28), size: .init(width: 0, height: 48))
        
        view.addSubview(podcastImage)
        podcastImage.centerXTo(view.centerXAnchor)
        podcastImage.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 48).isActive = true
        podcastImage.constrainWidth(view.frame.width / 2)
        podcastImage.heightAnchor.constraint(equalTo: podcastImage.widthAnchor, multiplier: 1.0/1.0).isActive = true
        
        view.addSubview(trackSlider)
        trackSlider.anchor(top: podcastImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 42, left: 18, bottom: 0, right: 18), size: .init(width: 0, height: 26))
        
        
        let durationsStackView = UIStackView(arrangedSubviews: [startTimeLabel, finishTimeLabel])
        durationsStackView.distribution = .fillEqually
        view.addSubview(durationsStackView)
        durationsStackView.anchor(top: trackSlider.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 18, bottom: 0, right: 18), size: .init(width: 0, height: 24))

    }
    
}
