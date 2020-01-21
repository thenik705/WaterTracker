//
//  CalendarCollectionViewController.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import DateUtilsKit

protocol CalendarDelegate: class {
    func selectDay(_ calendar: CalendarCollectionViewController, _ day: Day)
}

class CalendarCollectionViewController: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var calendarDelegate: CalendarDelegate?

    var days = Day.values()
    var rootController: MainViewController!

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
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayItemCell.identifier, for: indexPath) as! DayItemCell
        let rowDay = days[indexPath.row]

        cell.loadCell(rowDay, rowDay.getId() == rootController.selectedDay.getId())
        cell.progressView.progress = CGFloat(rowDay.progress)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowDay = days[indexPath.row]
        calendarDelegate?.selectDay(self, rowDay)
    }

    // MARK: - Settings
    func initSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: NSNotification.Name(rawValue: "eventChanged"), object: nil)

        getDayNumbers()

        dataSource = self
        delegate = self
        collectionViewLayout = makeLayout()

        backgroundColor = nil
    }

    // MARK: - Objc functions
    @objc func updateInfo() {
        getDayNumbers()
        reloadData()
    }

    // MARK: - Additional functions
    func setController(_ controller: MainViewController) {
        self.rootController = controller
    }

    func getDayNumbers() {
        var startNumber = 0
        var indexNumberDay = 0

        if var startWeekDay = Date().startOfWeek {
            if let endWeekDay = Date().endOfWeek {
                while startWeekDay <= endWeekDay {
                    startNumber = DateUtils.getDayNumberCalendar(startWeekDay)
                    if indexNumberDay <= days.count {
                        let rowDay = days[indexNumberDay]
                        rowDay.dayNumber = startNumber
                        rowDay.progress = Day.getDayProgress(startWeekDay)
                        rowDay.date = startWeekDay
                    }

                    startWeekDay = DateUtils.addDays(startWeekDay, days: 1)
                    indexNumberDay += 1
                }
            }
        }
    }

    func makeLayout() -> UICollectionViewLayout {
        let sizeHeight = 70//55 - 5ka

        let layout = UICollectionViewCompositionalLayout { (section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.absolute(CGFloat(sizeHeight))))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .absolute(CGFloat(sizeHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: self.days.count)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
        return layout
    }
}
