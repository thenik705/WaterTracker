//
//  TypeCollectionView.swift
//  WaterTracker
//
//  Created by nik on 27.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import UIKit
import CoreDataKit

protocol CategoriesCollectionViewControllerDelegate: class {
    func selectCategories(_ category: Categories?)
}

class CategoriesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var categories = [Categories]()
    var addIndexInt = Const.MAX_CATEGORIES_COUNT
    var isMainCategories = true

    var columnLayout: WaterColumnFlowLayout?
    var nowSelectCategory: Categories?

    weak var categoriesDelegate: CategoriesCollectionViewControllerDelegate?

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
        return getCountCell() + (isMainCategories ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowCategory = indexPath.row == addIndexInt ? nil : categories[indexPath.row]

        if isMainCategories {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryMainItemCell.identifier, for: indexPath) as! CategoryMainItemCell

            cell.loadCell(rowCategory, shouldColorCell: true)
            cell.categoryEventName.text = ""//rowCategory != nil && isMainCategories ? (indexPath.row == 0 ? "Минеральная" : (indexPath.row == 1 ? "Чёрный" : "Латте")) : ""
            cell.categoryEventNameConstraint?.constant = 5
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.identifierId, for: indexPath) as! CategoryItemCell
            cell.loadCell(rowCategory, shouldColorCell: nowSelectCategory == rowCategory)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowCategory = indexPath.row == addIndexInt ? nil : categories[indexPath.row]

        if isMainCategories {
            categoriesDelegate?.selectCategories(rowCategory)
        } else if let nowCategory = rowCategory {
            nowSelectCategory = nowSelectCategory == nowCategory ? nil : nowCategory
            categoriesDelegate?.selectCategories(nowSelectCategory)
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let rowCategory = indexPath.row == addIndexInt ? nil : categories[indexPath.row]

        if rowCategory == nil || !isMainCategories {
            return nil
        }

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let add = UIAction(title: "Добавить напиток", image: UIImage(systemName: "plus"), identifier: nil) { _ in
                print("button clicked..")
            }

            let edit = UIAction(title: "Изменить", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { _ in
                self.categoriesDelegate?.selectCategories(rowCategory)
            }

            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "link"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .on, handler: { _ in
                print("delete clicked.")
            })

            return UIMenu(title: "", image: nil, identifier: nil, children: [add, edit, delete])
        }

        return configuration
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryMainItemCell {
                cell.categoryBG.transform = .init(scaleX: 0.95, y: 0.95)
//                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryMainItemCell {
                cell.categoryBG.transform = .identity
//                cell.contentView.backgroundColor = .clear
            }
        }
    }

     func initSettings() {
        dataSource = self
        delegate = self

        columnLayout = WaterColumnFlowLayout(
            isMainLayout: isMainCategories,
            cellsPerRow: addIndexInt-1,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        )

        collectionViewLayout = columnLayout!

        isScrollEnabled = false
        backgroundColor = nil

        loadTypes()
    }

    // MARK: - Additional functions
    func loadTypes() {
        categories = CoreDataManager.loadFromDb(clazz: Categories.self, keyForSort: Const.SORT_POSITION, loadCount: addIndexInt)
        reloadData()
    }

    func getCountCell() -> Int {
        return categories.count >= addIndexInt && isMainCategories ? addIndexInt : categories.count
    }

    func updateCategories(_ nowCategory: Categories?) {
        nowSelectCategory = nowCategory
        reloadData()
    }
}
