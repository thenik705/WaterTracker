//
//  CategoriesCell.swift
//  WaterTracker
//
//  Created by nik on 27.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class CategoriesCell: UITableViewCell {

    static let identifier = "CategoriesCell"

    @IBOutlet weak var typeCollectionView: CategoriesCollectionView!

    func loadCell(_ nowSelectCategory: Categories? = nil, _ isMainCategories: Bool = true) {
        typeCollectionView.isMainCategories = isMainCategories
        typeCollectionView.nowSelectCategory = nowSelectCategory

        contentView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
