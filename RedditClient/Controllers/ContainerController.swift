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
    var panDistance = CGFloat(0)


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
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        if recognizer.state == UIGestureRecognizer.State.ended {
            self.panDistance = self.panDistance + translation.x
        } else {
            print(self.panDistance)
            print(translation.x)
            let bounds = UIScreen.main.bounds
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.menuController.view.frame.origin.x = -self.menuController.menuWidth + (self.panDistance + translation.x)
            }, completion: nil)
        }
    }
}

