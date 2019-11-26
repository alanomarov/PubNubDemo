//
//  WelcomeViewController.swift
//  PubNumDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    var welcomeView: WelcomeView {
        return view as! WelcomeView
    }
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Welcome", bundle: nil)
    }
    
    static func instantiate() -> UIViewController {
        guard let controller =
            WelcomeViewController.storyboard.instantiateInitialViewController() as?
            WelcomeViewController else {
            fatalError("View controller can't be instantiated")
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let username = welcomeView.userNameTextField.text, !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            ChatManager.shared.configure(config: Config.getConfigForUser(user: username))
            UserDefaults.standard.set(username, forKey: savedUUIDString)
            
            self.dismiss(animated: true)
        }
    }
}
