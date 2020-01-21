//
//  DayWaterView.swift
//  WaterTracker
//
//  Created by Nik on 26.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

@IBDesignable
class DayWaterView: UIView {

    @IBOutlet weak var grayDayLabel: UILabel!
    @IBOutlet weak var topDayLabel: UILabel!
    @IBOutlet weak var bottomDayLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let bundle = Bundle.init(for: DayWaterView.self)
        if let viewsToAdd = bundle.loadNibNamed("DayWaterView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }

    let layerStartDay = CAShapeLayer()
    let layerEndDay = CAShapeLayer()

    var height: CGFloat = 0

    var progress: CGFloat = 0 {
        didSet {
            height = self.frame.size.height * (1 - progress / 100)

            if (progress >= 110) {
                doStopAnim()
            }
        }
    }

    func loadViewInfo(_ topText: String, _ medText: String, _ botText: String, _ isActive: Bool = false) {
        height = self.frame.size.height
        self.layer.masksToBounds = true

        grayDayLabel.textColor = isActive ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        grayDayLabel.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.5)
        grayDayLabel.attributedText = attributedLabel(topText, medText, botText)

        topDayLabel.textColor = isActive ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) :  #colorLiteral(red: 0.2962678109, green: 0.2962678109, blue: 0.2962678109, alpha: 1)
        topDayLabel.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        topDayLabel.attributedText = attributedLabel(topText, medText, botText)
        topDayLabel.layer.mask = layerStartDay
        layerStartDay.frame = topDayLabel.frame

        bottomDayLabel.textColor = isActive ? #colorLiteral(red: 0.9756061435, green: 0.9737038016, blue: 0.9764146209, alpha: 1) : #colorLiteral(red: 0.2962678109, green: 0.2962678109, blue: 0.2962678109, alpha: 1)
        bottomDayLabel.backgroundColor = isActive ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.923729147, green: 0.9378063798, blue: 0.9489911557, alpha: 1)
        bottomDayLabel.attributedText = attributedLabel(topText, medText, botText)
        layerEndDay.frame = bottomDayLabel.frame
        bottomDayLabel.layer.mask = layerEndDay

        wave()

        waveHeight = isActive ? 2 : 0
    }

    var link: CADisplayLink?
    var offset: CGFloat = 2
    let speed: CGFloat = 0.5
    var waveWidth: CGFloat = 0
    var waveHeight: CGFloat = 0

    func wave() {
        if link == nil {
            link = CADisplayLink(target: self, selector: #selector(doAni))
            link?.add(to: .current, forMode: .common)
        }
    }

    @objc func doAni() {
        waveWidth = self.frame.size.width

        offset += speed

        let pathRef: CGMutablePath = CGMutablePath()
        let startY = Double(waveHeight) * sin(Double(offset) * .pi / Double(waveWidth))
        pathRef.move(to: CGPoint(x: 0, y: startY))

        var iItem: CGFloat = 0.0
        while iItem <= waveWidth {

            let yItem = 1.1 * Float(waveHeight) * sinf((Float(2.5 * .pi * Double(iItem) / Double(waveWidth))) + Float((Double(offset) * .pi / Double(waveWidth)))) + Float(height)
            iItem += 0.1
            pathRef.addLine(to: CGPoint(x: iItem, y: CGFloat(yItem)))
        }
        pathRef.addLine(to: CGPoint(x: waveWidth, y: 0))
        pathRef.addLine(to: CGPoint(x: 0, y: 0))
        pathRef.closeSubpath()
        layerStartDay.path = pathRef
        layerStartDay.fillColor = UIColor.lightGray.cgColor
        layerStartDay.strokeColor = UIColor.lightGray.cgColor

        let pathRef2: CGMutablePath = CGMutablePath()
        let startY2 = Double(waveHeight) * sin(Double(offset) * .pi / 3.0 / Double(waveWidth))
        pathRef2.move(to: CGPoint(x: -5, y: startY2))

        var jItem: CGFloat = 0.0
        while jItem <= waveWidth {

            let y2 = 1.1 * Float(waveHeight) * sinf((Float(2.5 * .pi * Double(jItem) / Double(waveWidth))) + Float((Double(offset) * .pi / Double(waveWidth))) + Float(.pi / 3.0)) + Float(height)
            jItem += 0.1
            pathRef2.addLine(to: CGPoint(x: jItem, y: CGFloat(y2)))
        }

        pathRef2.addLine(to: CGPoint(x: waveWidth, y: bottomDayLabel.frame.size.height))
        pathRef2.addLine(to: CGPoint(x: 0, y: bottomDayLabel.frame.size.height))
        pathRef2.closeSubpath()
        layerEndDay.path = pathRef2
        layerEndDay.fillColor = UIColor.lightGray.cgColor
        layerEndDay.strokeColor = UIColor.green.cgColor
    }

    func doStopAnim() {
        link?.invalidate()
        link = nil
    }

    func attributedLabel(_ topText: String, _ medText: String, _ botText: String) -> NSAttributedString {
        let numberAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold)]
        let dayAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10, weight: .medium)]

        let numberAttributedString = NSMutableAttributedString(string: "\(topText) \n", attributes: numberAttrs)
        let dayAttributedString = NSMutableAttributedString(string: medText, attributes: dayAttrs)

        numberAttributedString.append(dayAttributedString)

        return numberAttributedString
    }
}
