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
    var backgroundController: BackgroundController?
    var menuVisible = false
    var menuXDistance: CGFloat = 0
    let maxYForPan: CGFloat = 20
    let menuAnimationLength = 0.4
    let maxAlpha: CGFloat = 0.55
    let maxPanToOpen: CGFloat = 80
    var moved = false
    var panGestureRecognizer: UIPanGestureRecognizer!


    override func viewDidLoad() {
        // todo: the syoer will call the parebt view did load so you can implment and abstract method for this
        // todo: also you should try and make it so the background view controller works so that its just the background of the menucontroller you're changing the colour of
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureHomeController()
        configureMenuController()
        // todo: look into hidebaronswipe for swiping up to hide the nav bar
        setupMenuStyling()
    }

    // MARK: Setup

    func configureHomeController() {
        homeController = HomeController()
        view.addSubview(homeController.view)
        addChild(homeController)
        homeController.didMove(toParent: self)
        // Todo: Use screen  edge pan recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        homeController.view.addGestureRecognizer(panGestureRecognizer)
    }

    func configureMenuController() {
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        menuController = MenuController()
        menuController.delegate = self
        currentWindow?.addSubview(menuController.view)
    }

    func setupMenuStyling() {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    }

    // MARK: Menu

    func addBackgroundController() {
        if backgroundController == nil {
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            backgroundController = BackgroundController()
            currentWindow?.insertSubview(backgroundController!.view!, belowSubview: menuController.view)
            addChild(backgroundController!)
            backgroundController?.didMove(toParent: self)
        }
    }

    func removeBackgroundController() {
        if backgroundController != nil {
            backgroundController!.willMove(toParent: nil)
            backgroundController!.view.removeFromSuperview()
            backgroundController!.removeFromParent()
            backgroundController = nil
        }
    }

    func animateMenu(xPosition: CGFloat, alpha: CGFloat, finishedFunction: (() -> Void)?) {
        UIView.animate(withDuration: menuAnimationLength, animations: {
            self.menuController.view.frame.origin.x = xPosition
            self.backgroundController!.view.backgroundColor = UIColor(white: 0.3, alpha: alpha)
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
        return percentageOfWidthMoved
    }

    func closeMenu(finishedAnimationFunction: (() -> Void)? = nil) {
        self.menuXDistance = 0
        self.animateMenu(xPosition: -self.menuController.menuWidth, alpha: 0, finishedFunction: { () in
            if finishedAnimationFunction != nil {
                finishedAnimationFunction!()
            }
            self.homeController.view.addGestureRecognizer(self.panGestureRecognizer)
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            currentWindow?.removeGestureRecognizer(self.panGestureRecognizer)
        })
        // This has to be after the animateMenu function call because it uses the controller
        self.removeBackgroundController()
    }

    func openMenu() {
        self.menuXDistance = self.menuController.menuWidth
        self.animateMenu(xPosition: 0, alpha: self.maxAlpha, finishedFunction: { () in
            self.homeController.view.removeGestureRecognizer(self.panGestureRecognizer)
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            currentWindow?.addGestureRecognizer(self.panGestureRecognizer)
        })
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
                self.addBackgroundController()
                self.animateMenu(xPosition: -self.menuController.menuWidth + menuMoveDistance, alpha: calculateAlpha(menuMoveDistance: menuMoveDistance), finishedFunction: nil)
                moved = true
            }
        }
    }

    func presentMenuOption(menuOptionSelected: MenuOptions) {
        switch menuOptionSelected {
        case .Profile:
            let controller = ProfileController()
            controller.modalPresentationStyle = .overCurrentContext
            navigationController?.pushViewController(controller, animated: true)
        default:
            let controller = ProfileController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }


}

extension ContainerController: MenuControllerDelegate {
    func handleMenuSelectOption(menuOptionSelected: MenuOptions) {
        self.closeMenu(finishedAnimationFunction: { () in
            self.presentMenuOption(menuOptionSelected: menuOptionSelected)
        })
    }
}


