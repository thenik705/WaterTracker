//
//  Utils.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import AudioToolbox

internal extension DateComponents {
    mutating func to12am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }

    mutating func to12pm() {
        self.hour = 23
        self.minute = 59
        self.second = 59
    }
}

class Utils {
    private let soundDirectory = "/System/Library/Audio/UISounds"

    static func system(_ name: String, pointSize: CGFloat, weight: UIImage.SymbolWeight) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        return UIImage(systemName: name, withConfiguration: config)
    }

    func sounSystem(_ soundFileName: String) {
        let fullyQualifiedName = soundDirectory + "/" + soundFileName
        let url = URL(fileURLWithPath: fullyQualifiedName)
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
}

extension Date {
    func dayNumberOfWeek() -> Int {
        let calendar = Calendar.current
        var dayOfWeek = calendar.component(.weekday, from: self) + (Calendar.current.firstWeekday - 1) - calendar.firstWeekday
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        return dayOfWeek
    }

    func getDayNumber() -> Int {
        return Calendar.current.component(.day, from: self)
    }

    func toLocalTime() -> Date {
        let timeZone = NSTimeZone.local
        let seconds : TimeInterval = Double(timeZone.secondsFromGMT(for: self as Date))
        let localDate = Date(timeInterval: seconds, since: self as Date)
        return localDate as Date
    }

    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    var startOfWeek: Date? {
        var calendar = Calendar.current
        var component = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        component.to12am()
        calendar.firstWeekday = Calendar.current.firstWeekday
        return calendar.date(from: component)!
    }

    var endOfWeek: Date? {
        let calendar = Calendar.current
        var component = DateComponents()
        component.weekOfYear = 1
        component.day = -1
        component.to12pm()
        return calendar.date(byAdding: component, to: startOfWeek!)
    }

        var startOfWeek2: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 1, to: sunday)
        }

        var endOfWeek2: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 7, to: sunday)
        }
}

extension UILabel {
    func countLabelLines() -> Int {
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font]
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: attributes as [NSAttributedString.Key : Any],
                                            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }

    func isTruncated() -> Bool {
        return (self.countLabelLines() > self.numberOfLines)
    }
}

extension UIFont {

    enum Font: String {
        case SFUIText = "SFUIText"
        case SFUIDisplay = "SFUIDisplay"
    }

    private static func name(of weight: UIFont.Weight) -> String? {
        switch weight {
            case .ultraLight: return "UltraLight"
            case .thin: return "Thin"
            case .light: return "Light"
            case .regular: return nil
            case .medium: return "Medium"
            case .semibold: return "Semibold"
            case .bold: return "Bold"
            case .heavy: return "Heavy"
            case .black: return "Black"
            default: return nil
        }
    }

    convenience init?(font: Font, weight: UIFont.Weight, size: CGFloat) {
        var fontName = ".\(font.rawValue)"
        if let weightName = UIFont.name(of: weight) { fontName += "-\(weightName)" }
        self.init(name: fontName, size: size)
    }
}

extension UIViewController {
    func disnissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.disnissKeyboardTappedAround(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func disnissKeyboardTappedAround(_ gestureRecognizer: UIPanGestureRecognizer) {
        dismissKeyboard()
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            return image
        }

        return nil
    }
}

extension UIButton {

    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }

    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }

    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }

    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }

    func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControl.State) {
        self.setImage(image, for: state)

        if let frame = frame {
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
    }
}
