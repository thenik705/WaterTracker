//
//  AddCountCell.swift
//  WaterTracker
//
//  Created by nik on 06.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class AddCountCell: UITableViewCell {

    static let identifier = "AddCountCell"

    @IBOutlet weak var cellBG: GradientView!
    @IBOutlet weak var cellText: UITextField!
    @IBOutlet weak var subText: UILabel!
    @IBOutlet weak var measurementText: UILabel!
    @IBOutlet weak var viewMeasurementWidth: NSLayoutConstraint!

    weak var delegate: AddTextCellDelegate?

    var rowEventEntity: Event?
    var isWelcome = false
    
    func loadCell(_ eventEntity: Event?, _ placeholder: String? = "К примеру: 250 мл") {
        rowEventEntity = eventEntity

        updateCount(rowEventEntity?.getStrVolume())

        cellText.placeholder = placeholder
        cellText.delegate = self

        cellText.attributedPlaceholder = NSAttributedString(string: cellText.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)])

        backgroundColor = .clear
    }

    func updateCount(_ newStrCount: String? = nil) {
        cellText.text = newStrCount

        var countVolue: Double = 0.0

        if let strCount = newStrCount {
            if strCount.isNumeric() {
                if let newCount = strCount.toDouble() {
                    countVolue = newCount
                }
            }
        }

        subText.text = "С учетом градации, вы выпили «\(countVolue) мл»"
        rowEventEntity?.volume = "\(countVolue)"
    }

    @IBAction func selectTextAction(_ sender: Any) {
        cellText.becomeFirstResponder()
    }
}

class WelcomeCountCell: AddCountCell {

    static let welcomeIdentifier = "WelcomeCountCell"

    func loadCell() {
        isWelcome = true

        cellText.placeholder = "К примеру: 50 кг"
        cellText.delegate = self

        cellText.attributedPlaceholder = NSAttributedString(string: cellText.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)])

        backgroundColor = .clear
    }

    override func updateCount(_ newStrCount: String? = nil) {
        cellText.text = newStrCount

        var countVolue: Double = 0.0

        if let strCount = newStrCount {
            if strCount.isNumeric() {
                if let newCount = strCount.toDouble() {
                    countVolue = newCount
                }
            }
        }

//        rowEventEntity?.volume = "\(countVolue)"
    }
}

extension AddCountCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {

        if let text = textField.text {
            viewMeasurementWidth.constant = text.isNotEmpty() && !isWelcome ? 30 : 0
            measurementText.alpha = text.isNotEmpty() && !isWelcome ? 1 : 0
        }

        delegate?.cellDidChangeSelection(self, textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cellDidEndEditing(self)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.cellDidBeginEditing(self)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.cellFieldShouldBeginEditing(self) ?? true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.cellFieldShouldEndEditing(self) ?? true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.cellTextField(textField, range: range, string: string, editingCell: self) ?? false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.cellTapDeleteButton(self) ?? true
    }
}
