//
//  ContainerController.swift
//  RedditClient
//
//  Created by Tharuka Devendra on 05/08/2019.
//  Copyright © 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {

    var menuController: MenuController!
    var homeController: HomeController!
    var isEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureHomeController()
        configureMenuController()
    }

    func configureHomeController() {
        homeController = HomeController()
        homeController.delegate = self
        view.addSubview(homeController.view)
        addChild(homeController)
        homeController.didMove(toParent: self)
    }

    func configureMenuController() {
        menuController = MenuController()
        view.addSubview(menuController.view)
        addChild(menuController)
        menuController.didMove(toParent: self)
    }

}


extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle() {
        let bounds = UIScreen.main.bounds
        isEnabled = !isEnabled
        if isEnabled {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.menuController.view.frame.origin.x = -bounds.width + 150
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.menuController.view.frame.origin.x = -bounds.width
            }, completion: nil)
        }
    }
}

