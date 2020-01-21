//
//  TableSectionHeader.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol TableSectionHeaderViewDelegate: class {
//    func tappedSection(_ sectionType: DateRangeEntity?)
}

class TableSectionHeader: UITableViewHeaderFooterView {

    static let identifier = "TableSectionHeader"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var allButton: UIButton!

    @IBOutlet weak var subTitleHeight: NSLayoutConstraint!

    weak var delegate: TableSectionHeaderViewDelegate?

    var rowSection: Sections?
    var countMaxLabel = 0

    func loadSection(_ section: Sections, _ categories: Bool = true) {
        rowSection = section

        title.text = rowSection?.title ?? ""
        setSubTextSection("", categories)
    }

    func isShowAllButton(_ show: Bool = false) {
        allButton.alpha = show ? 1 : 0
    }

    func setSubTextSection(_ subText: String = "", _ categories: Bool = true) {
        var newSubTitle = rowSection?.subTitle ?? ""
        if let section = rowSection {
            let type = section.getType()

            if (type === SectionEntity.Icons || type === SectionEntity.Count) && section.title.isNotEmpty() {
                if type === SectionEntity.Icons {
                    newSubTitle += categories ? "категории" : "напитка"
                }

                newSubTitle += subText.isNotEmpty() ? " «\(subText)»" : ""
            }
        }

        subTitle.text = newSubTitle

        if subTitle.countLabelLines() >= 2 {
            if let text = subTitle.text {
                countMaxLabel = countMaxLabel == 0 ? text.count-5 : countMaxLabel

                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: countMaxLabel)
                let newText = text[startIndex...endIndex]

                subTitle.text = newText + "...»"
            }
        }

        subTitleHeight.constant = newSubTitle.isNotEmpty() ? 20 : 0
    }

    @IBAction func tappedAllButtonAction(_ sender: Any) {
//        delegate?.tappedSection(section?.type)
    }
}
