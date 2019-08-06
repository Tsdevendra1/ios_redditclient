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
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGestureRecognizer)
        configureHomeController()
        configureMenuController()
    }

    func configureHomeController() {
        homeController = HomeController()
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

    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let menuMoveDistance = self.menuXDistance + translation.x

        print(translation.x)
        if recognizer.state == UIGestureRecognizer.State.ended {
            if translation.x < 80 {
                self.menuXDistance = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.menuController.view.frame.origin.x = -self.menuController.menuWidth
                }, completion: nil)
            } else {
                self.menuXDistance = self.menuController.menuWidth
                UIView.animate(withDuration: 0.3, animations: {
                    self.menuController.view.frame.origin.x = 0
                }, completion: nil)
            }
        } else if menuMoveDistance <= self.menuController.menuWidth {
            UIView.animate(withDuration: 0.3, animations: {
                self.menuController.view.frame.origin.x = -self.menuController.menuWidth + menuMoveDistance
            }, completion: nil)
        }
    }

}


