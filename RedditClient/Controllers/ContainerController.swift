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
    var menuXDistance: CGFloat = 0
    let maxYForPan: CGFloat = 20
    let menuAnimationLength = 0.4
    let maxAlpha: CGFloat = 0.55
    let maxPanToOpen: CGFloat = 80
    var moved = false


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Todo: Use screen  edge pan recognizer
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
        menuController.delegate = self
        view.addSubview(menuController.view)
        addChild(menuController)
        menuController.didMove(toParent: self)
    }

    func animateMenu(xPosition: CGFloat, alpha: CGFloat, finishedFunction: (() -> Void)?) {
        UIView.animate(withDuration: menuAnimationLength, animations: {
            self.menuController.view.frame.origin.x = xPosition
            self.homeController.view.backgroundColor = UIColor(white: 1, alpha: alpha)
            self.view.backgroundColor = UIColor(white: 1, alpha: alpha)
        }, completion: { (_) in
            if let function = finishedFunction {
                function()
            }
        })
    }

    func calculateAlpha(menuMoveDistance: CGFloat) -> CGFloat {
        var percentageOfWidthMoved = menuMoveDistance / (self.menuController.menuWidth / self.maxAlpha)
        if percentageOfWidthMoved > self.maxAlpha {
            percentageOfWidthMoved = self.maxAlpha
        } else if percentageOfWidthMoved < 0 {
            percentageOfWidthMoved = 0
        }
        return (1 - percentageOfWidthMoved)
    }

    func closeMenu(finishedAnimationFunction: (() -> Void)?) {
        self.menuXDistance = 0
        self.animateMenu(xPosition: -self.menuController.menuWidth, alpha: 1, finishedFunction: finishedAnimationFunction)
    }

    func openMenu() {
        self.menuXDistance = self.menuController.menuWidth
        self.animateMenu(xPosition: 0, alpha: (1 - self.maxAlpha), finishedFunction: nil)
    }

    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let menuControllerViewIndex = view.subviews.firstIndex(of: self.menuController.view)
        if recognizer.state == UIGestureRecognizer.State.began && menuControllerViewIndex != nil && menuControllerViewIndex != 1 {
            view.bringSubviewToFront(menuController.view)
        }
        let translation = recognizer.translation(in: view)
        print("panning", translation.x)
        let menuMoveDistance = self.menuXDistance + translation.x

        if -maxYForPan <= translation.y && translation.y <= maxYForPan || recognizer.state == UIGestureRecognizer.State.ended || moved {
            if recognizer.state == UIGestureRecognizer.State.ended {
                if translation.x < self.maxPanToOpen {
                    self.closeMenu(finishedAnimationFunction: nil)
                } else {
                    self.openMenu()
                }
                moved = false
            } else if menuMoveDistance <= self.menuController.menuWidth {
                self.animateMenu(xPosition: -self.menuController.menuWidth + menuMoveDistance, alpha: calculateAlpha(menuMoveDistance: menuMoveDistance), finishedFunction: nil)
                moved = true
            }
        }
    }

    func presentMenuOptionController(menuOptionSelected: MenuOptions) {
        var controller: UIViewController
        switch menuOptionSelected {
        case .Profile:
            controller = ProfileController()
            controller.modalPresentationStyle = .overCurrentContext
            AppDelegate.shared.rootViewController.switchToProfile()
        default:
            controller = ProfileController()
        }
    }


}

extension ContainerController: MenuControllerDelegate {
    func handleMenuSelectOption(menuOptionSelected: MenuOptions) {
        self.closeMenu(finishedAnimationFunction: { () in
            self.presentMenuOptionController(menuOptionSelected: menuOptionSelected)
        })
    }


}


