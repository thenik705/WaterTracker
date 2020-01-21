//
//  AddIconsCollectionView.swift
//  WaterTracker
//
//  Created by Nik on 05.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

protocol IconsCollectionViewControllerDelegate: class {
    func selectIcon(_ newIcon: WaterImage)
}

class AddIconsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var iconsDelegate: IconsCollectionViewControllerDelegate?

    var images = WaterImage.values()
    var rootController: AddViewController!

    var nowSelectImage = WaterImage.imageDefault

    var columnLayout: WaterColumnFlowLayout?

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }

    // MARK: - Settings
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

    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconItemCell.identifier, for: indexPath) as! IconItemCell
        let rowImage = images[indexPath.row]
        let isSelect = rowImage.getId() == nowSelectImage.getId()
        let nowColor = isSelect ? rootController.nowSelectColor : nil

        cell.loadCell(rowImage, nowColor, isSelect)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowImage = images[indexPath.row]
        iconsDelegate?.selectIcon(rowImage)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            UIView.animate(withDuration: 0.3) {
                if let cell = collectionView.cellForItem(at: indexPath) as? ColorItemCell {
                    cell.colorView.transform = .init(scaleX: 0.95, y: 0.95)
                }
            }
        }

        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            UIView.animate(withDuration: 0.3) {
                if let cell = collectionView.cellForItem(at: indexPath) as? ColorItemCell {
                    cell.colorView.transform = .identity
                }
            }
        }

    // MARK: - Settings
    func initSettings() {
        columnLayout = WaterColumnFlowLayout(
            cellsPerRow: 6,
            cellHeight: 50,
            minimumInteritemSpacing: 5,
            minimumLineSpacing: 5,
            sectionInset: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        )

        dataSource = self
        delegate = self
        collectionViewLayout = columnLayout!
        isScrollEnabled = false
        backgroundColor = nil
    }

    // MARK: - Additional functions
    func setController(_ controller: AddViewController) {
        self.rootController = controller
    }

    func updateImage(_ nowColor: WaterImage) {
        nowSelectImage = nowColor
        reloadData()
    }
}
