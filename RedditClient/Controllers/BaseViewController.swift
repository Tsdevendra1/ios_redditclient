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
        navBar.delegate = self
        navBar.barTintColor = .white
        navBar.isTranslucent = false

        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        let item = createBasicNavItem()
        if let navItem = item as? UINavigationItem {
            navBar.items = [navItem]
        }
    }

    func createBasicNavItem() -> UINavigationItem {
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
