//
//  ViewController.swift
//  WaterTracker
//
//  Created by Nik on 16.01.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit
//4798 4899 4912 5190
//5201
import UIKit
import AudioToolbox

class SoundListViewController: UITableViewController {
    private var soundList: [String] = []
    private let soundDirectory = "/System/Library/Audio/UISounds"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseId")
        soundList = FileManager.default.enumerator(atPath: soundDirectory)!.map { String(describing: $0) }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        let soundFileName = soundList[indexPath.row]
        
        print(soundFileName)
        
        let fullyQualifiedName = soundDirectory + "/" + soundFileName
        let url = URL(fileURLWithPath: fullyQualifiedName)

        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        cell.textLabel?.text = "\(soundFileName) \(soundId)"
       
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundFileName = soundList[indexPath.row]
        print(soundFileName)
        
        let fullyQualifiedName = soundDirectory + "/" + soundFileName
        let url = URL(fileURLWithPath: fullyQualifiedName)
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
}
