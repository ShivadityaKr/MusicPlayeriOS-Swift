//
//  PlayerVC.swift
//  MusicPlayer
//
//  Created by Shivaditya Kumar on 15/03/22.
//

import UIKit
import AVFoundation

class PlayerVC: UIViewController {
    public var position: Int = 0
    public var songs: [Song] = []
    @IBOutlet var holder: UIView!
    var player: AVAudioPlayer?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    func configure(){
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else {
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else {
                return
            }
            player.play()
        }
        catch {
            print("Error occured")
        }
      
        albumImageView.image = UIImage(named: song.imageName)
        //labels
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        // buttons
        playPauseButton.addTarget(self, action: #selector(didPlayPauseButtonTapp), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didBackButtonTapp), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didNextButtonTapp), for: .touchUpInside)
        seekBack.addTarget(self, action: #selector(didSeekBackTap), for: .touchUpInside)
        seekForward.addTarget(self, action: #selector(didSeekForwardTap), for: .touchUpInside)
        // playback slider
        playbackSlider!.minimumValue = 0
        
        playbackSlider.maximumValue = Float(round(self.player?.duration ?? 0.0))
        startTimeLabel.text = String(round(self.player?.currentTime ?? 0.0))
        endTimeLabel.text = String(round(self.player?.duration ?? 0.0) / 60)
        DispatchQueue.main.async {
            if self.player!.isPlaying {
                self.changeValueForLabel()
            }
        }
    }
    private func changeValueForLabel(){
        startTimeLabel.text = String(round(self.player?.currentTime ?? 0.0))
    }
    @objc func didSeekBackTap(){
        if player?.currentTime != 0 {
            player?.currentTime = player!.currentTime - 10
        }
    }
    @objc func didSeekForwardTap(){
        if player?.currentTime != player?.duration {
            player?.currentTime = player!.currentTime + 10
        }
    }
    @objc func didNextButtonTapp(){
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            configure()
        }
    }
    @objc func didBackButtonTapp(){
        if position > 0 {
            position = position - 1
            player?.stop()
            configure()
        }
    }
    @objc func didPlayPauseButtonTapp(){
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}
