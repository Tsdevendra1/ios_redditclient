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
    var backgroundController: BackgroundController!
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
        configureHomeController()
        configureMenuController()
        setupMenuStyling()
    }

    // MARK: Setup

    func configureHomeController() {
        homeController = HomeController()
        view.addSubview(homeController.view)
        addChild(homeController)
        homeController.didMove(toParent: self)
    }

    func configureMenuController() {
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        backgroundController = BackgroundController()
        currentWindow?.addSubview(backgroundController.view)

        menuController = MenuController()
        menuController.delegate = self
        currentWindow?.addSubview(menuController.view)

        // Todo: Use screen  edge pan recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        currentWindow?.addGestureRecognizer(panGestureRecognizer)
    }

    func setupMenuStyling() {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    }

    // MARK: Menu

    func animateMenu(xPosition: CGFloat, alpha: CGFloat, finishedFunction: (() -> Void)?) {
        print(alpha)
        UIView.animate(withDuration: menuAnimationLength, animations: {
            self.menuController.view.frame.origin.x = xPosition
            self.backgroundController.view.backgroundColor = UIColor(white: 1, alpha: alpha)
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

    func closeMenu(finishedAnimationFunction: (() -> Void)? = nil) {
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

    func presentMenuOption(menuOptionSelected: MenuOptions) {
        var controller: UIViewController
        switch menuOptionSelected {
        case .Profile:
            controller = ProfileController()
            controller.modalPresentationStyle = .overCurrentContext
        default:
            controller = ProfileController()
        }
        navigationController?.pushViewController(controller, animated: true)
    }


}

extension ContainerController: MenuControllerDelegate {
    func handleMenuSelectOption(menuOptionSelected: MenuOptions) {
        self.closeMenu(finishedAnimationFunction: { () in
            self.presentMenuOption(menuOptionSelected: menuOptionSelected)
        })
    }


}


