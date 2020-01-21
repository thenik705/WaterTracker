//
//  WatersCell.swift
//  WaterTracker
//
//  Created by Nik on 26.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class WatersCell: UITableViewCell {

    static let identifier = "WatersCell"

    @IBOutlet weak var watersCollectionView: WatersCollectionView!

    func loadCell(_ waters: [Water]? = [Water](), _ isMainWaters: Bool = true) {
        watersCollectionView.isMainWaters = isMainWaters
        watersCollectionView.updateWaters(waters ?? [Water]())
        contentView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
