//
//  PlayerVC.swift
//  MusicPlayer
//
//  Created by Shivaditya Kumar on 15/03/22.
//

import UIKit
import AVFoundation
import MediaPlayer
class PlayerVC: UIViewController {
    private let commandCenter = MPRemoteCommandCenter.shared()
    public var position: Int = 0
    public var songs: [Song] = []
    @IBOutlet var holder: UIView!
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    @IBOutlet var albumImageView : UIImageView!
    @IBOutlet var songNameLabel : UILabel!
    @IBOutlet var artistNameLabel : UILabel!
    @IBOutlet var albumNameLabel : UILabel!
    @IBOutlet var backButton : UIButton!
    @IBOutlet var nextButton : UIButton!
    @IBOutlet var playPauseButton : UIButton!
    @IBOutlet var seekBack : UIButton!
    @IBOutlet var seekForward : UIButton!
    @IBOutlet var playbackSlider : UISlider!
    @IBOutlet var startTimeLabel : UILabel!
    @IBOutlet var endTimeLabel : UILabel!
    @IBOutlet var stackView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadUI()
        inActiveView()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.configure()
        }
    }
    private func setCommandTargets() {
        // If you don't want to activate buttons, You can just call this API below.
        // UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // Set the closures to process user's activites.
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.player?.play()
            self?.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.player?.pause()
            self?.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            guard let positionEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            
            print("posion: \(positionEvent.positionTime)")
            self?.player?.play()
            
            return .success
        }
    }
    func activeView() {
        stackView.alpha = 1
    }
    func inActiveView() {
        stackView.alpha = 0.3
    }
    override func viewDidLayoutSubviews() {
        
    }
    func loadUI(){
        let song = songs[position]
        albumImageView.image = UIImage(named: song.imageName)
        //labels
        songNameLabel.text = song.name
        self.startTimeLabel.text = "--:--"
        self.endTimeLabel.text = "--:--"
        artistNameLabel.text = song.artistName
        playbackSlider!.maximumValue = 0
        playPauseButton.setTitle("", for: .normal)
        backButton.setTitle("", for: .normal)
        nextButton.setTitle("", for: .normal)
        seekBack.setTitle("", for: .normal)
        seekForward.setTitle("", for: .normal)
        playPauseButton.layer.cornerRadius = 25
        playPauseButton.backgroundColor = .black
        albumImageView.layer.cornerRadius = 25
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        albumImageView.layer.shadowColor = UIColor.black.cgColor
        albumImageView.layer.shadowOpacity = 1
        albumImageView.layer.shadowOffset = CGSize.zero
        albumImageView.layer.shadowRadius = 10
    }
    func configure(){
        let song = songs[position]
        let url = URL(string: song.trackName )
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        
        // buttons
        playPauseButton.addTarget(self, action: #selector(didPlayPauseButtonTapp), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didBackButtonTapp), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didNextButtonTapp), for: .touchUpInside)
        seekBack.addTarget(self, action: #selector(didSeekBackTap), for: .touchUpInside)
        seekForward.addTarget(self, action: #selector(didSeekForwardTap), for: .touchUpInside)
        // playback slider
        playbackSlider!.minimumValue = 0
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = false
        playbackSlider!.tintColor = .black
        playbackSlider?.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                let endTime : Float64 = CMTimeGetSeconds(self.player!.currentItem!.duration);
                self.playbackSlider!.value = Float ( time )
                let secs = Int(time)
                let endSecs = Int(endTime)
                self.startTimeLabel.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String
                self.endTimeLabel.text = NSString(format: "%02d:%02d", endSecs/60, endSecs%60) as String
                self.activeView()
                self.setCommandTargets()
            }
        }
        
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    private func changeValueForLabel(){
        //        startTimeLabel.text = String(round(self.player?.currentTime ?? 0.0))
    }
    @objc func didSeekBackTap(){
        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
        let seconds : Int64 = Int64(round(time))
        let targetTime:CMTime = CMTimeMake(value: seconds - 10, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @objc func didSeekForwardTap(){
        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
        let seconds : Int64 = Int64(round(time))
        let targetTime:CMTime = CMTimeMake(value: seconds + 10, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @objc func didNextButtonTapp(){
        if position < (songs.count - 1) {
            position = position + 1
            player?.pause()
            loadUI()
            inActiveView()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configure()
            }
        }
    }
    @objc func didBackButtonTapp(){
        if position > 0 {
            position = position - 1
            player?.pause()
            loadUI()
            inActiveView()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configure()
            }
        }
    }
    @objc func didPlayPauseButtonTapp(){
        if player?.rate != 0
        {
            player!.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player!.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.pause()
            player.replaceCurrentItem(with: nil)
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}
