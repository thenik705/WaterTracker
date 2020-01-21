//
//  AddColorsCollectionView.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

protocol ColorsCollectionViewControllerDelegate: class {
    func selectColor(_ newColor: WaterColor)
}

class AddColorsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var colorsDelegate: ColorsCollectionViewControllerDelegate?

    var colors = WaterColor.values()
    var rootController: AddViewController!

    var lastSelectColor = WaterColor.SkyBlue
    var nowSelectColor = WaterColor.SkyBlue

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
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorItemCell.identifier, for: indexPath) as! ColorItemCell
        let rowColor = colors[indexPath.row]
        let isSelect = rowColor.getId() == nowSelectColor.getId()

        cell.loadCell(rowColor, isSelect)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rootController?.lastSelectColor = nowSelectColor

        let rowColor = colors[indexPath.row]
        colorsDelegate?.selectColor(rowColor)
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

    func updateColor(_ lastColor: WaterColor, _ nowColor: WaterColor) {
        lastSelectColor = lastColor
        nowSelectColor = nowColor

        reloadData()
    }
}
