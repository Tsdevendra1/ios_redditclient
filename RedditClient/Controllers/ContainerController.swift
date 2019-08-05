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
        print("Hi")
    }
}

