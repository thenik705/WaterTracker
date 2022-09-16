//
//  WelcomeViewController.swift
//  WaterTracker
//
//  Created by Nik on 27.04.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit
import Hero

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeTableView: WelcomeTableViewController!

    var rootController: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initSettings()

        disnissKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Settings
    func initSettings() {
    }

    // MARK: - Actions
    @IBAction func continueButtonAction(_ sender: Any) {
        let controller = Const.GET_STORYBOARD.instantiateViewController(withIdentifier: "WelcomeSettingsViewController") as! WelcomeSettingsViewController

        controller.modalPresentationStyle = .overCurrentContext
        navigationController?.present(controller, animated: true, completion: nil)
    }

    // MARK: - Additional functions

    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

    //        override var preferredStatusBarStyle: UIStatusBarStyle {
    //            return self.lightStatusBar ? .lightContent : .default
    //        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWelcomeSettings" {
            let welcomeSettings = segue.destination as! WelcomeSettingsViewController
            welcomeSettings.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .auto)
        }
    }
}
