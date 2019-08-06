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
    var menuVisible = false
    var menuXDistance = CGFloat(0)


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

    func handleMenuClose() {

    }

}


extension ContainerController: HomeControllerDelegate {
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let menuMoveDistance = (self.menuXDistance + translation.x)
        print(menuMoveDistance)
        if recognizer.state == UIGestureRecognizer.State.ended {
            print("ended")
            if (menuMoveDistance > self.menuController.menuWidth) {
                print("max")
                self.menuXDistance = self.menuController.menuWidth
            } else if (menuMoveDistance < 0) {
                print("min")
                self.menuXDistance = 0
            } else {
                print("else")
                self.menuXDistance = menuMoveDistance
            }
//        } else if translation.x < 0 {
//            self.handleMenuClose()
        } else if menuMoveDistance <= self.menuController.menuWidth {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.menuController.view.frame.origin.x = -self.menuController.menuWidth + menuMoveDistance
            }, completion: nil)
        }
    }
}

