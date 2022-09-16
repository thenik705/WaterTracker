//
//  WelcomeSettingsViewController.swift
//  WaterTracker
//
//  Created by Nik on 28.04.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class WelcomeSettingsViewController: UIViewController {

    @IBOutlet weak var welcomeSettingsTableView: WelcomeSettingsTableViewController!

    var rootController: WelcomeViewController?

    var lightStatusBar = false
    var sectionType: SectionType = .welcomeSettings

    override func viewDidLoad() {
        super.viewDidLoad()
        initSettings()

        disnissKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lightStatusBar = true
        self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Settings
    func initSettings() {
        self.welcomeSettingsTableView.setController(self)
        self.welcomeSettingsTableView.loadInfo(self.sectionType)

//        let image = Utils.system(isNewEntity ? "plus.circle.fill" : "square.and.pencil", pointSize: 20, weight: .bold)
//        addEditButton.setImage(image, for: .normal)
//        addEditButton.setTitle(isNewEntity || sectionType == .addWater ? "Добавить" : "Изменить", for: .normal)
    }
    
    // MARK: - Actions

    // MARK: - Additional functions
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.lightStatusBar ? .lightContent : .default
    }
}
