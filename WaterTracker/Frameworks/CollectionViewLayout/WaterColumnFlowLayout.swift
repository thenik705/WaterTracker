//
//  WaterColumnFlowLayout.swift
//  WaterTracker
//
//  Created by Nik on 30.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class WaterColumnFlowLayout: UICollectionViewFlowLayout {
    let cellsPerRow: Int
    let cellHeight: CGFloat
    let isMainLayout: Bool
    
    init(isMainLayout: Bool = true, cellsPerRow: Int, cellHeight: CGFloat = 105, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.isMainLayout = isMainLayout
        self.cellsPerRow = cellsPerRow
        self.cellHeight = cellHeight
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: isMainLayout ? itemWidth : 200, height: cellHeight)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
