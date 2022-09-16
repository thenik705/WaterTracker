//
//  AddPreviewEventCell.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class AddPreviewEventCell: UITableViewCell {

    static let identifier = "AddPreviewEventCell"

    @IBOutlet weak var eventBG: GradientView!
    @IBOutlet weak var eventImage: UIImageView!

    func loadCell(_ color: WaterColor?, image: WaterImage?) {
        var (top, down) = (#colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1), #colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1))
        var imageEvent = WaterImage.imageDefault.getImage()

        if let newColor = color {
           (top, down) = newColor.getColor()
        }

        if let newImage = image {
            imageEvent = newImage.getImage()
        }
        
        eventBG.topColor = top
        eventBG.bottomColor = down

        eventImage.image = imageEvent

        backgroundColor = .clear
    }

    func updateImage(_ newImage: WaterImage) {
        eventImage.image = newImage.getImage()
    }
}
