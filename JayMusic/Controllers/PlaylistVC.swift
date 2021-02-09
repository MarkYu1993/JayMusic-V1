//
//  ViewController.swift
//  JayMusic
//
//  Created by Mark Yu on 2021/2/5.
//  Copyright © 2021 Mark Yu. All rights reserved.
//

import UIKit

class PlaylistVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var songs = [SongType]()
    
    var songIndex: Int?
    
    @IBOutlet weak var playMusicBtn: UIButton!
    @IBOutlet weak var randomPlayBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var musicButton: [UIButton]!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongCell
        cell.numberLabel.text = String( indexPath.row + 1)
        cell.songNameLabel.text = songs[indexPath.row].trackName
        
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songIndex = tableView.indexPathForSelectedRow?.row
        performSegue(withIdentifier: "goToMusic", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - Actions
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            songIndex = 0
        } else {
            songIndex = Int.random(in: 0 ... songs.count-1)
        }
        performSegue(withIdentifier: "goToMusic", sender: self)
    }
    

    
    @IBSegueAction func segueAction(_ coder: NSCoder) -> MusicVC? {
    
        let controller = MusicVC(coder: coder)
        controller?.songIndex = songIndex
        
        return controller
    }
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // 按鈕
        self.playMusicBtn.layer.cornerRadius = 20
        self.randomPlayBtn.layer.cornerRadius = 20
        ITuneController.shared.fetchITuneData { (songs) in
            self.songs = songs!
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
        
    }


}

