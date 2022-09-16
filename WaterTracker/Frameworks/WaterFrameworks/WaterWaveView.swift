//
//  WaterWaveView.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class WaterWaveView: UIView {

    let layerStartDay = CAShapeLayer()
    let layerEndDay = CAShapeLayer()
    
    let grayDayLabel = UILabel()
    let topDayLabel = UILabel()
    let bottomDayLabel = UILabel()
    
    let layerStartName = CAShapeLayer()
    let layerEndName = CAShapeLayer()
    
    let grayNameLabel = UILabel()
    let topNameLabel = UILabel()
    let bottomNameLabel = UILabel()
    
    var height: CGFloat = 0
    
    var progress: CGFloat = 0 {
        didSet {
            height = self.frame.size.height * (1 - progress / 100)
            
            if (progress >= 110) {
                doStopAnim()
            }
        }
    }

    override var frame: CGRect {
        didSet {
            grayDayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
            topDayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
            bottomDayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
            
            layerStartDay.frame = topDayLabel.frame
            layerEndDay.frame = bottomDayLabel.frame

            height = frame.size.height
        }
    }
    
    override func layoutSubviews() {
    }
    
    func loadViewInfo(_ number: String, _ day: String, _ isActive: Bool = false, _ progress: CGFloat) {
        self.height = self.frame.size.height
        self.layer.masksToBounds = true
        
        grayDayLabel.textColor = isActive ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        grayDayLabel.backgroundColor = isActive ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.5) : #colorLiteral(red: 0.5608925223, green: 0.5605969429, blue: 0.5822194815, alpha: 1)
        grayDayLabel.textAlignment = .center
        grayDayLabel.numberOfLines = 0
        grayDayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        grayDayLabel.attributedText = attributedLabel(grayDayLabel, number, day)
        self.addSubview(grayDayLabel)
        
        topDayLabel.textColor = isActive ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        topDayLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topDayLabel.textAlignment = .center
        topDayLabel.numberOfLines = 0
        topDayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        topDayLabel.attributedText = attributedLabel(topDayLabel, number, day)
        topDayLabel.layer.mask = layerStartDay
        layerStartDay.frame = topDayLabel.frame
        self.addSubview(topDayLabel)
        
        bottomDayLabel.textColor = isActive ? #colorLiteral(red: 0.9434816241, green: 0.9393909574, blue: 0.9685646892, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bottomDayLabel.backgroundColor = isActive ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : progress == 0 ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8975696564, green: 0.9223318696, blue: 0.9304484725, alpha: 1)
        bottomDayLabel.textAlignment = .center
        bottomDayLabel.numberOfLines = 0
        bottomDayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        bottomDayLabel.attributedText = attributedLabel(bottomDayLabel, number, day)
        layerEndDay.frame = bottomDayLabel.frame
        bottomDayLabel.layer.mask = layerEndDay
        self.addSubview(bottomDayLabel)

        wave()
        
        waveHeight = isActive ? 2 : 0
        self.progress = progress
    }
    
    var link: CADisplayLink?
    var offset: CGFloat = 2
    let speed: CGFloat = 0.5
    var waveWidth: CGFloat = 0
    var waveHeight: CGFloat = 0
    
    func wave() {
        if link == nil {
            link = CADisplayLink(target: self, selector: #selector(doAni))
            link?.add(to: RunLoop.current, forMode: .common)
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
    
    func attributedLabel(_ label: UILabel, _ number: String, _ day: String) -> NSAttributedString {
        let numberAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold)]
        let dayAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10, weight: .medium)]

        let numberAttributedString = NSMutableAttributedString(string: "\(number) \n", attributes: numberAttrs)
        let dayAttributedString = NSMutableAttributedString(string: day, attributes: dayAttrs)

        numberAttributedString.append(dayAttributedString)

        return numberAttributedString
    }
}
