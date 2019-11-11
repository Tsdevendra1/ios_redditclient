//
// Created by Tharuka Devendra on 2019-08-20.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit


class BaseViewController: UIViewController {

    var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createBasicNavBar()
    }


    func createBasicNavBar() {
        // create navigation bar
        navBar = UINavigationBar()
        navBar.layer.shadowOpacity = 0.5
        navBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        navBar.layer.shadowRadius = 1.5
        navBar.layer.shadowColor = UIColor.black.cgColor
        navBar.delegate = self
        navBar.barTintColor = .white
        navBar.isTranslucent = false

        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        let navItem = createNavbarItem()
        navBar.items = [navItem]
    }

    func createNavbarItem() -> UINavigationItem {
        fatalError("Must override")
    }

    @objc func dismissView(for navBar: UINavigationItem) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension BaseViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
