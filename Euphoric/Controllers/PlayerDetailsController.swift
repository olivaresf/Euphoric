//
//  PlayerDetailsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 14/08/20.
//

import UIKit
import AVKit
import Lottie
import MediaPlayer

class PlayerDetailsController: UIViewController {
    
    var episode:Episode!{
        didSet{
            episodeTitle.text = episode.title
            podcastImage.sd_setImage(with: URL(string: episode.imageUrl ?? ""))
            playEpisode()
        }
    }
    
    
    let fullView: CGFloat = 140
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) - 60
    }
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .default)
    
    let player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    fileprivate func playEpisode(){
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: playerItem)
        
        player.play()
    }

    var soundAnimation:AnimationView = {
        let animation = AnimationView(name: "bars")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.backgroundBehavior = .pauseAndRestore
//        animation.play()
        return animation
    }()
    
    let podcastImage = RoundedImageView(image: #imageLiteral(resourceName: "person"))
    
    let currentTimeSlider:UISlider = {
        let slider = UISlider()
        slider.backgroundColor = .clear
        slider.tintColor = .systemPink
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    let episodeTitle = TitleLabel(title: "Play your favorite Podcast and swipe me 😜", size: 16)
    
    let currentTimeLabel:UILabel  = {
        let label = UILabel()
        label.text = "00:00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let durationTimeLabel:UILabel  = {
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
        btn.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemPink
        return btn
    }()
    
    let playButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.contentMode = .scaleAspectFit
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .default)
        let largeBoldDoc = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
        btn.setImage(largeBoldDoc, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .fill
        btn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleForward(){
        let fifteenSeconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @objc func handleSliderChange(){
        #warning("Research prints and fix jumpy slider")
        let percentage = currentTimeSlider.value
        
        guard let duration = player.currentItem?.duration else {return}
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
    }
    
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak self] (time) in
            guard let self = self else {return}
            self.currentTimeLabel.text = time.toDisplayString()
            self.durationTimeLabel.text = self.player.currentItem?.duration.toDisplayString()
            self.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func updateCurrentTimeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds  = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    fileprivate func setupAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print("Fail to activate session: ", err)
        }
    }
    
    fileprivate func setupRemoteControl(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: self.largeConfig), for: .normal)
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: self.largeConfig), for: .normal)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
    }
    
    fileprivate func observePlayerStart() {
        let time = CMTimeMake(value: 1, timescale: 10)
        let times = NSValue(time: time)
        
        player.addBoundaryTimeObserver(forTimes: [times], queue: .main) { [weak self] in
            guard let self = self else {return}
            self.soundAnimation.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: self.largeConfig), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupRemoteControl()
        setupAudioSession()
        observePlayerCurrentTime()
        observePlayerStart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPlayerDetail()
    }
    
    func showPlayerDetail(){
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused{
            soundAnimation.play()
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: largeConfig), for: .normal)
        }else{
            soundAnimation.pause()
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
        }
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
    
    let topStackView = UIStackView()
    
    fileprivate func setupViews(){
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
//        view.addGestureRecognizer(gesture)
        topStackView.addGestureRecognizer(gesture)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        
        soundAnimation.constrainWidth(40)
        playButton.constrainWidth(28)
        goForwardButton.constrainWidth(28)
        
        [soundAnimation ,episodeTitle, playButton, goForwardButton].forEach{topStackView.addArrangedSubview($0)}
        
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
        
        view.addSubview(currentTimeSlider)
        currentTimeSlider.anchor(top: podcastImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 42, left: 18, bottom: 0, right: 18), size: .init(width: 0, height: 26))
        
        
        let durationsStackView = UIStackView(arrangedSubviews: [currentTimeLabel, durationTimeLabel])
        durationsStackView.distribution = .fillEqually
        view.addSubview(durationsStackView)
        durationsStackView.anchor(top: currentTimeSlider.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 18, bottom: 0, right: 18), size: .init(width: 0, height: 24))

    }
    
}
