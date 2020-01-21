//
//  AddCategoriesCollectionView.swift
//  WaterTracker
//
//  Created by nik on 07.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import UIKit

class AddCategoriesCollectionView: CategoriesCollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSettings()
    }

    override func initSettings() {
        dataSource = self
        delegate = self

        backgroundColor = nil

        loadTypes()
    }
}
