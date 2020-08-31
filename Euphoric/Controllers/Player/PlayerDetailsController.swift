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
            playButton.setImage(UIImage.withSymbol(type: .play, size: 30, weight: .bold), for: .normal)
            soundAnimation.pause()
            episodeTitle.text = episode.title
            alert.title = episode.title
            guard let imageUrl = URL(string: episode.imageUrl ?? "") else {return}
            absorbeAverageColor(of: imageUrl)
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
            setPodcastImageandCC(with: imageUrl)
            runShakePlayerAnimation()
        }
    }
    
    var partialView: CGFloat { return UIScreen.main.bounds.height - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) - 60 }
    
    fileprivate let generator = UIImpactFeedbackGenerator(style: .medium)
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate var blurEffect = UIBlurEffect()
    fileprivate var blurredEffectView = UIVisualEffectView()
    
    let player:AVQueuePlayer = {
        let avPlayer = AVQueuePlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    lazy var currentTimeSlider:UISlider = {
        let slider = EphSlider()
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    let episodeTitle = CustomLabel(text: "Play your favorite Podcast and swipe me!", size: 16, weight: .medium, textColor: .normalDark, numberOfLines: 2)
    
    let currentTimeLabel = CustomLabel(text: "00:00:00", size: 16, weight: .regular, textColor: .normalDark)
    
    let durationTimeLabel = CustomLabel(text: "00:00:00", size: 16, weight: .regular, textColor: .normalDark, textAlignment: .right)
    
    lazy var goForwardButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.withSymbol(type: .forward30, weight: .regular), for: .normal)
        btn.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .normalDark
        return btn
    }()
    
    lazy var playButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.withSymbol(type: .play, size: 30, weight: .bold), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .normalDark
        btn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return btn
    }()
    
    lazy var dotsButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.withSymbol(type: .dots, weight: .regular), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .normalDark
        btn.addTarget(self, action: #selector(handleSheet), for: .touchUpInside)
        return btn
    }()
    
    lazy var randomButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.withSymbol(type: .download, weight: .regular), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .normalDark
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    lazy var soundAnimation:AnimationView = {
        let animation = AnimationView(name: "bars")
        let keypath = AnimationKeypath(keys: ["**", "Fill 1", "**", "Color"])
        let colorProvider = ColorValueProvider(UIColor.normalDark.lottieColorValue)
        animation.setValueProvider(colorProvider, keypath: keypath)
        
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.backgroundBehavior = .pauseAndRestore
        
        return animation
    }()
    
    let podcastImage = RoundedImageView(image: #imageLiteral(resourceName: "headphones"))
    
    fileprivate func runShakePlayerAnimation(){
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -20)
        } completion: { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.3, initialSpringVelocity: 1.3, options: .curveEaseOut) {
                self.view.transform = .identity
            } completion: { (_) in }
        }
    }
    
    fileprivate func playEpisode(){
        if episode.fileUrl != nil{
            playEpisodeUsingFileUrl()
        }else{
            guard let url = URL(string: episode.streamUrl) else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    fileprivate func playEpisodeUsingFileUrl(){
        print("Playing episode with file url:", episode.fileUrl ?? "")
        guard let fileUrl = URL(string: episode.fileUrl ?? "") else {return}
        let fileName = fileUrl.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        trueLocation.appendPathComponent(fileName)
        
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    fileprivate func setPodcastImageandCC(with imageUrl:URL) {
        podcastImage.sd_setImage(with: imageUrl)
        podcastImage.sd_setImage(with: imageUrl) { (image, _, _, _) in
            let image = self.podcastImage.image ?? UIImage()
            let artworkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                return image
            })
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
        }
    }
    
    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    
    func setupAlerts(){
        alert.view.tintColor = .label
        
        let firstAction = UIAlertAction(title: "Episode details", style: .default) { (_) in
            let eDetailsController = EpisodeDetailsController()
            eDetailsController.episode = self.episode
            self.present(eDetailsController, animated: true)
        }
        firstAction.setValue(UIImage.withSymbol(type: .info, size: 20, weight: .regular), forKey: "image")
        alert.addAction(firstAction)
        
        let shareAlert = UIAlertAction(title: "Share episode", style: .default) { (_) in
            print("Share alert")
        }
        shareAlert.setValue(UIImage.withSymbol(type: .share, size: 20, weight: .regular), forKey: "image")
        alert.addAction(shareAlert)
        
        let playNextAlert = UIAlertAction(title: "Play next", style: .default) { (_) in
            print("Share alert")
        }
        playNextAlert.setValue(UIImage.withSymbol(type: .info, size: 20, weight: .regular), forKey: "image")
        alert.addAction(playNextAlert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(dismissAction)
    }
    
    @objc func handleSheet(){
        self.present(alert, animated: true)
    }
    
    @objc func handleForward(){
        let fifteenSeconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @objc func handleSliderChange(slider: UISlider, event: UIEvent){
    
        let percentage = currentTimeSlider.value
        
        guard let duration = player.currentItem?.duration else {return}
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        player.seek(to: seekTime)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                player.pause()
                playButton.setImage(UIImage.withSymbol(type: .play, size: 30, weight: .bold), for: .normal)
                soundAnimation.pause()
            case .ended:
                player.play()
                playButton.setImage(UIImage.withSymbol(type: .pause, size: 30, weight: .bold), for: .normal)
                soundAnimation.play()
            default:
                break
            }
        }
        
    }
    
    func absorbeAverageColor(of imageUrl:URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.setupAdaptiveColors(color: image.averageColor ?? UIColor.normalDark)
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func setupAdaptiveColors(color:UIColor){
        self.gradientLayer.colors = [color.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        
        let keypath = AnimationKeypath(keys: ["**", "Fill 1", "**", "Color"])
        let colorProvider = ColorValueProvider(color.lottieColorValue)
        self.soundAnimation.setValueProvider(colorProvider, keypath: keypath)
        
        self.currentTimeSlider.tintColor = color
        self.dotsButton.tintColor = color
        self.routePickerView.tintColor = color
        self.randomButton.tintColor = color
    }
    
    
    fileprivate func setupNowPlayingInfo(){
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
            self.soundAnimation.play()
            self.playButton.setImage(UIImage.withSymbol(type: .pause, size: 30, weight: .bold), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.soundAnimation.stop()
            self.playButton.setImage(UIImage.withSymbol(type: .play, size: 30, weight: .bold), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
    }
    
    fileprivate func setupElapsedTime(playbackRate:Float){
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }
    
    fileprivate func observePlayerStart() {
        let time = CMTimeMake(value: 1, timescale: 10)
        let times = NSValue(time: time)
        
        player.addBoundaryTimeObserver(forTimes: [times], queue: .main) { [weak self] in
            guard let self = self else {return}
            print("playing")
            self.generator.impactOccurred()
            self.soundAnimation.play()
            self.playButton.setImage(UIImage.withSymbol(type: .pause, size: 30, weight: .bold), for: .normal)
            self.setupLockscreenDuration()
        }
    }
    
    
    fileprivate func setupLockscreenDuration(){
        guard let duration = player.currentItem?.duration else {return}
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    fileprivate func setupInterruptionObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc func handleInterruption(notification:Notification){
        guard let userInfo = notification.userInfo else {return}
        
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else {return}
        
        if type == AVAudioSession.InterruptionType.began.rawValue{
            print("Interruption began")
            soundAnimation.stop()
            playButton.setImage(UIImage.withSymbol(type: .play, size: 30, weight: .bold), for: .normal)
        }else{
            print("Interruption ended")
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {return}
            
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue{
                soundAnimation.play()
                player.play()
                playButton.setImage(UIImage.withSymbol(type: .pause, size: 30, weight: .bold), for: .normal)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupViews()
        setupAlerts()
        setupRemoteControl()
        setupInterruptionObserver()
        observePlayerCurrentTime()
        observePlayerStart()
    }
    
    func setupGradient(){
        gradientLayer.colors = [UIColor.topColor.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0, 0.5]
        gradientLayer.opacity = 1
        view.layer.addSublayer(gradientLayer)
        
        blurEffect = UIBlurEffect(style: .extraLight)
        
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func showPlayerDetail(){
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    @objc func handlePlayPause(){
        generator.impactOccurred()
        if player.timeControlStatus == .paused{
            soundAnimation.play()
            player.play()
            playButton.setImage(UIImage.withSymbol(type: .pause, size: 30, weight: .bold), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
        }else{
            soundAnimation.pause()
            player.pause()
            playButton.setImage(UIImage.withSymbol(type: .play, size: 30, weight: .bold), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if episode != nil{
            let translation = recognizer.translation(in: self.view)
            let velocity = recognizer.velocity(in: self.view)
            let y = self.view.frame.minY
            if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
                self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            
            print(y)
            print(translation.y)
            
            if recognizer.state == .ended {
                var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
                duration = duration > 1.3 ? 1 : duration
                
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.allowUserInteraction]) {
                    if  velocity.y >= 0 {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    }
                }
            }
            
            //            if self.view.frame.origin.y == self.fullView{
            //                UIView.animate(withDuration: 0.3) {
            //                    self.playButton.layer.opacity = 0
            //                }
            //            }
            //
            //            if self.view.frame.origin.y == self.partialView{
            //                UIView.animate(withDuration: 0.3) {
            //                    self.playButton.layer.opacity = 1
            //                }
            //            }
            
        }
        
        
    }
    
    let topStackView = UIStackView()
    
    var fullView:CGFloat!
    
    let routePickerView = AVRoutePickerView()
    
    fileprivate func setupViews(){
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(swipeGesture)
        
        var constant:CGFloat = 0
        
        if DeviceTypes.isiPhoneXsMaxAndXr {
            constant = 70
        }
        
        if DeviceTypes.isiPhoneX || DeviceTypes.isiPhone8PlusStandard{
            constant = 140
        }
        
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8PlusZoomed{
            constant = 160
        }
        //
        fullView = view.frame.height / 2 - constant
        
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
        
        
        routePickerView.tintColor = .normalDark
        
        let bottomStack = UIStackView(arrangedSubviews: [UIView(), dotsButton, routePickerView, randomButton, UIView()])
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        view.addSubview(bottomStack)
        bottomStack.anchor(top: durationsStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
    }
    
}
