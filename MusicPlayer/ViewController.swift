//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Shivaditya Kumar on 15/03/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        songs.append(Song(name: "Viva la da", albumName: "Album 3", artistName: "Cold Play", imageName: "2", trackName: "https://s3.amazonaws.com/kargopolov/kukushka.mp3"))
        songs.append(Song(name: "Background music", albumName: "Album 1", artistName: "Rando", imageName: "1", trackName: "https://s3.amazonaws.com/kargopolov/kukushka.mp3"))
        songs.append(Song(name: "Havana", albumName: "Album 2", artistName: "Camibla", imageName: "3", trackName: "https://s3.amazonaws.com/kargopolov/kukushka.mp3"))
        tableView.delegate = self
        tableView.dataSource = self
    }
    var songs = [Song]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont( name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont( name: "Helvetica", size: 16)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // present the player
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerVC else {
            return
        }
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
    }
}
struct Song {
    let name : String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
