//
//  MusicVC.swift
//  JayMusic
//
//  Created by Mark Yu on 2021/2/5.
//  Copyright © 2021 Mark Yu. All rights reserved.
//

import UIKit
import AVFoundation

class MusicVC: UIViewController {
    
    var songs = [SongType]()
    
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    var timeObserverToken: Any?

    var songIndex: Int!
    
    var isPlaying = true
    
    var timer = Timer()
    
    var currentTimeInSec: Float!
    var totalTimeInSec: Float!
    var remainingTimeInSec: Float!
    
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songProgress: UIProgressView!
    
    @IBOutlet var timeLabel: [UILabel]!
    
    @IBOutlet var playButton: [UIButton]!
    
    
    // MARK: - 音量設定

    @IBAction func volumeButtonPressed(_ sender: UIButton) {
        if sender.tag == 11 {
            player.isMuted = true
        } else {
            player.isMuted = false
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        let sliderValue = sender.value
        player.volume = sliderValue
    }
    
    // MARK: - 音樂播放
    @IBAction func playButtonPressed(_ sender: UIButton) {
        switch sender.tag {
            
        case 1:
            if songIndex == 0 {
                songIndex = songs.count - 1
            } else {
                songIndex -= 1
            }
            
            playButton[1].setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic()
            
        case 2:
            isPlaying ? player.pause() : player.play()
            sender.setImage(UIImage(systemName: isPlaying ? "play.fill" :  "pause.fill"), for: .normal)
            isPlaying = !isPlaying

        case 3:
            if songIndex == songs.count - 1 {
                songIndex = 0
            } else {
                songIndex += 1
            }
            
            playButton[1].setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic()

        default:
            print("播放鍵錯誤")
 
        }
    }
    
    func playMusic() {
        removePeriodicTimeObserver()
        
        // 音樂播放
        let songURL = songs[songIndex].previewUrl
        playerItem = AVPlayerItem(url: songURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        // 更新歌曲資訊
        DispatchQueue.main.async {
            self.updateInfo()
        }
        
        // 更新圖片
        ITuneController.shared.fetchImage(urlStr: songs[songIndex].artworkUrl100) { (image) in
            DispatchQueue.main.async {
                self.songImageView.image = image
            }
        }
        
        // Time observer
        addPeriodicTimeObserver()
        
    }
    
    func updateInfo() {
        let currentSong = songs[songIndex]
        songNameLabel.text = currentSong.trackName
        artistLabel.text = currentSong.artistName
    }
    
    
    // MARK: - 音樂進度條
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            let duration = self?.playerItem.asset.duration
            let second = CMTimeGetSeconds(duration!)
            self!.totalTimeInSec = Float(second)
            
            let songCurrentTime = self?.player.currentTime().seconds
            self!.currentTimeInSec = Float(songCurrentTime!)
            
            self!.updateProgressUI()
            
        }
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    //更新UI進度
    func updateProgressUI() {
        
        if currentTimeInSec == totalTimeInSec {
            removePeriodicTimeObserver()
        } else {
            remainingTimeInSec = totalTimeInSec - currentTimeInSec
            timeLabel[0].text = timeConverter(currentTimeInSec)
            timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
            songProgress.progress = currentTimeInSec / totalTimeInSec
        }
        
    }
    
    //時間轉換
    func timeConverter(_ timeInSecond: Float) -> String {
        let minute = Int(timeInSecond) / 60
        let second = Int(timeInSecond) % 60
        
        return second < 10 ? "\(minute):0\(second)" : "\(minute):\(second)"

    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 資料下載
        ITuneController.shared.fetchITuneData { (songs) in
            self.songs = songs!
            self.playMusic()
        }
        
        // AV Player
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { [weak self] (notification) in
            if self?.songIndex == (self?.songs.count)! - 1 {
                self?.songIndex = 0
            } else {
                self?.songIndex += 1
            }
            self?.playMusic()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removePeriodicTimeObserver()
    }

}
