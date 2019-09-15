//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

class RedditPostController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationController?.navigationBar.isHidden = true
        placeNavigationBar()
    }

    func placeNavigationBar() {

        // create navigation bar
        let navBar = UINavigationBar()
        navBar.delegate = self
        navBar.barTintColor = .white
        navBar.isTranslucent = false

        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        let item = UINavigationItem()
        item.title = "HI"
        let button = UIButton()
        button.setTitle("ThiS iS  test", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: button)
        item.leftBarButtonItems = [backBarButton]
        navBar.items = [item]
    }

    @objc func dismissView(for navBar: UINavigationItem){
        self.navigationController?.popViewController(animated: true)
    }


}


extension RedditPostController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
