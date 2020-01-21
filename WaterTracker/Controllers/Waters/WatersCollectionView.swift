//
//  WatersCollectionView.swift
//  WaterTracker
//
//  Created by Nik on 26.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import UIKit
import CoreDataKit

protocol WaterCollectionViewControllerDelegate: class {
    func selectWater(_ water: Water?, edit: Bool)
    func selectWaters(_ waters: [Water])
}

class WatersCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var waters = [Water]()
    var nowSelectWaters = [Water]()
    var addIndexInt = 0
    var isMainWaters = true {
        didSet {
            loadTypes()
        }
    }

    var columnLayout: WaterColumnFlowLayout?
    weak var waterDelegate: WaterCollectionViewControllerDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCountCell() + (isMainWaters ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowWater = indexPath.row == addIndexInt ? nil : waters[indexPath.row]

        if isMainWaters {
            let identifier = rowWater == nil ? WatersAddItemCell.addIdentifier : WatersItemCell.identifier

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WatersItemCell
            cell.loadCell(rowWater)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatersItemCell.identifier, for: indexPath) as! WatersItemCell
            let isSelectWater = nowSelectWaters.first(where: {$0 == rowWater}) != nil
            cell.loadCell(rowWater, shouldColorCell: isSelectWater)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowWater = indexPath.row == addIndexInt ? nil : waters[indexPath.row]

        if isMainWaters {
            waterDelegate?.selectWater(rowWater, edit: false)
        } else if let nowWater = rowWater {
            if nowSelectWaters.isEmpty {
                nowSelectWaters.append(nowWater)
            } else {
                if let index = nowSelectWaters.firstIndex(of: nowWater) {
                    nowSelectWaters.remove(at: index)
                } else {
                    nowSelectWaters.append(nowWater)
                }
            }
            waterDelegate?.selectWaters(nowSelectWaters)
        }
    }

//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let rowWater = indexPath.row == addIndexInt ? nil : waters[indexPath.row]
//
//        if rowWater == nil || !isMainWaters {
//            return nil
//        }
//
//        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            let add = UIAction(title: "Добавить значние", image: UIImage(systemName: "plus"), identifier: nil) { _ in
//                print("button clicked..")
//            }
//
//            let edit = UIAction(title: "Изменить", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { _ in
//                self.waterDelegate?.selectWater(rowWater, edit: true)
//            }
//
//            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "link"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .on, handler: { _ in
//                print("delete clicked.")
//            })
//
//            return UIMenu(title: "", image: nil, identifier: nil, children: [add, edit, delete])
//        }
//
//        return configuration
//    }

     func initSettings() {
        dataSource = self
        delegate = self

        columnLayout = WaterColumnFlowLayout(
            isMainLayout: isMainWaters,
            cellsPerRow: 4,
            cellHeight: 50,
            minimumInteritemSpacing: 5,
            minimumLineSpacing: 5,
            sectionInset: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        )

        collectionViewLayout = columnLayout!
        backgroundColor = nil

        loadTypes()
    }

    // MARK: - Additional functions
    func loadTypes() {
        waters = CoreDataManager.loadFromDb(clazz: Water.self, keyForSort: Const.SORT_POSITION, loadCount: isMainWaters ? Const.MAX_WATER_COUNT : 0)
        addIndexInt = isMainWaters ? waters.count >= Const.MAX_WATER_COUNT ? Const.MAX_WATER_COUNT : waters.count : waters.count
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.transitionCrossDissolve, UIView.AnimationOptions.beginFromCurrentState],
            animations: {
                self.reloadData()
        })
    }

    func getCountCell() -> Int {
        return waters.count >= addIndexInt && isMainWaters ? addIndexInt : waters.count
    }

    func updateWaters(_ nowWaters: [Water]) {
        nowSelectWaters = nowWaters
        reloadData()
    }
}
