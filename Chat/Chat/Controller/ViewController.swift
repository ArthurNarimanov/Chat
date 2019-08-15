//
//  ViewController.swift
//  Chat
//
//  Created by Ram on 13/08/2019.
//  Copyright © 2019 New tec. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc private func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

