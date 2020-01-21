//
//  AddEntityCell.swift
//  WaterTracker
//
//  Created by Nik on 01.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

protocol AddEntityDelegate: class {
    func tapAddEntity(_ cell: AddEntityCell)
}

class AddEntityCell: UITableViewCell {

    static let identifier = "AddEntityCell"

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addTitle: UILabel!

    @IBOutlet weak var addEntityButton: UIButton!

    weak var addEntityDelegate: AddEntityDelegate?

    func loadCell() {
        let image = system("plus.circle.fill", pointSize: 20, weight: .bold)

        addEntityButton.setImage(image, for: .normal)
        addEntityButton.setTitleColor(#colorLiteral(red: 0.09188886732, green: 0.5096402168, blue: 0.9950761199, alpha: 1), for: .normal)
        addEntityButton.startAnimatingPressActions()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func addEntityButtonAction(_ sender: Any) {
        addEntityDelegate?.tapAddEntity(self)
    }

    func system(_ name: String, pointSize: CGFloat, weight: UIImage.SymbolWeight) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        return UIImage(systemName: name, withConfiguration: config)
    }
}
