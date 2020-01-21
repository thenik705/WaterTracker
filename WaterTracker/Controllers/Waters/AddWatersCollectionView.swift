//
//  AddWatersCollectionView.swift
//  WaterTracker
//
//  Created by nik on 07.12.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import UIKit

class AddWatersCollectionView: WatersCollectionView {

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
