//
//  ProgressCell.swift
//  WaterTracker
//
//  Created by nik on 21.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class ProgressCell: UITableViewCell {

    static let identifier = "ProgressCell"

    @IBOutlet weak var progressView: MultiProgressView!
    @IBOutlet weak var progressCollectionView: ProgressCollectionView!
    @IBOutlet weak var progressDay: UILabel!
    @IBOutlet weak var initLabel: UILabel!

    func loadCell() {
        let dayVolume = WaterHelpers.instance.allVolume
        let allVolume = WaterHelpers.instance.maxVolumeDay
        let progress = String(format: "%.1f", WaterHelpers.instance.progress)

        progressDay.text = "\(dayVolume)/\(allVolume) (\(progress))%"
        progressView.dataSource = self

        loadInfo()
        progressCollectionView.progressView = progressView
        backgroundColor = .clear
    }

    func loadInfo() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
            let progress = Float(WaterHelpers.instance.progress/100)
            self.progressView.setProgress(section: 0, progress: progress)
        }, completion: { (_) -> Void in
            UIView.animate(withDuration: 0.3, delay: 2.5, options: [], animations: {
                self.progressView?.resetProgress()

                let allCategoryCountCell = self.progressCollectionView.getCountCell() - 1
                var allCategoryCountProgress: Float = 0

                for (index, category) in self.getCategories().enumerated() {
                    self.progressView?.resetProgress(index)
                    let eventsCategories = category.getEvents(WaterHelpers.instance.selectDay)
                    let progress = Float(WaterHelpers.instance.getProgreeEvents(eventsCategories))

                    if allCategoryCountCell != index {
                        allCategoryCountProgress += progress
                        self.progressView.setProgress(section: index, progress: progress/100, isReloadColor: category.getColorId())
                    }
                }

                if WaterHelpers.instance.progress != 0 {
                    self.progressView?.resetProgress(allCategoryCountCell)
                    let otherProgressCount = Float(WaterHelpers.instance.progress) - allCategoryCountProgress
                    self.progressView.setProgress(section: allCategoryCountCell, progress: otherProgressCount/100)
                }

                self.initLabel.alpha = 0
                self.progressCollectionView?.reloadData()
                self.progressCollectionView?.alpha = 1
            })
        })
    }

    func getCategories() -> [Categories] {
        return CoreDataManager.loadFromDb(clazz: Categories.self, keyForSort: Const.SORT_POSITION)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ProgressCell: MultiProgressViewDataSource {
    public func numberOfSections(in progressBar: MultiProgressView) -> Int {
        return getCategories().count + 1
    }

    public func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let rowCategory = getCategories().count == section ? nil : getCategories()[section]

        let bar = ProgressViewSection()

        if let category = rowCategory {
            bar.setColor(category.getColorId())
            bar.setTitle(category.getTitle())
        } else {
            bar.setColor(WaterColor.Grey.getId())
            bar.setTitle("Другое")
        }
        return bar
    }
}
