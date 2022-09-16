//
//  SettingsViewController.swift
//  WaterTracker
//
//  Created by nik on 10.01.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: SettingsTableViewController!

    var rootController: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initSettings()

        disnissKeyboardWhenTappedAround()
    }

    // MARK: - Settings
    func initSettings() {
        let buttonClose = Button.closeButton()
        buttonClose.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonClose)

        title = "Настройки"

        settingsTableView.setController(self)
        let controller = Const.GET_STORYBOARD.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController

        let nController = UINavigationController(rootViewController: controller)
        self.present(nController, animated: true, completion: nil)
    }

    // MARK: - Actions

    // MARK: - Additional functions

    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

    //        override var preferredStatusBarStyle: UIStatusBarStyle {
    //            return self.lightStatusBar ? .lightContent : .default
    //        }
}
