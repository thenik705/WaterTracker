//
//  AddTextCell.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol AddTextCellDelegate: class {
    func cellDidBeginEditing(_ editingCell: UITableViewCell)
    func cellDidEndEditing(_ editingCell: UITableViewCell)
    func cellDidChangeSelection(_ editingCell: UITableViewCell, _ textField: UITextField)
    func cellTapDeleteButton(_ editingCell: UITableViewCell) -> Bool
    func cellTextField(_ textField: UITextField, range: NSRange, string: String, editingCell: UITableViewCell) -> Bool
    func cellFieldShouldBeginEditing(_ editingCell: UITableViewCell) -> Bool
    func cellFieldShouldEndEditing(_ editingCell: UITableViewCell) -> Bool
}

class AddTextCell: UITableViewCell {

    static let identifier = "AddTextCell"

    @IBOutlet weak var cellBG: GradientView!
    @IBOutlet weak var cellText: UITextField!

    weak var delegate: AddTextCellDelegate?

    var rowEntity: ITitle?

    func loadCell(_ entity: ITitle?) {
        rowEntity = entity

        cellText.placeholder = "Название"
        cellText.text = entity?.getTitle()
        cellText.delegate = self

        cellText.attributedPlaceholder = NSAttributedString(string: cellText.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)])

        backgroundColor = .clear
    }
    @IBAction func selectTextAction(_ sender: Any) {
        cellText.becomeFirstResponder()
    }
}

extension AddTextCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
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
