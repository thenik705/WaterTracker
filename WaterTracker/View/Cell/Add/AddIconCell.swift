//
//  AddIconCell.swift
//  WaterTracker
//
//  Created by Nik on 05.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class AddIconCell: UITableViewCell {

    static let identifier = "AddIconCell"

    @IBOutlet weak var icons: AddIconsCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
