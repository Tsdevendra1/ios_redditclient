//
//  ContainerController.swift
//  RedditClient
//
//  Created by Tharuka Devendra on 05/08/2019.
//  Copyright © 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

protocol ContainerViewDelegate: class {
    func openMenu(maxAlpha: CGFloat, menuAnimationLength: Double)
    func handleMenuMove(menuWidth: CGFloat, alpha: CGFloat, xPosition: CGFloat, menuAnimationLength: Double)
    func closeMenu(finishedAnimationFunction: (() -> Void)?, menuAnimationLength: Double, menuWidth: CGFloat)
    func presentMenuOption(menuOptionSelected: MenuOptions)
}

class ContainerModel {
    var menuVisible = false
    var menuXDistance: CGFloat = 0
    let maxYForPan: CGFloat = 20
    let menuAnimationLength = 0.4
    let maxAlpha: CGFloat = 0.55
    let maxPanToOpen: CGFloat = 80
    var moved = false
    var menuWidth: CGFloat!
}

class ContainerPresenter {
    private let containerModel = ContainerModel()
    unowned private var containerViewDelegate: ContainerViewDelegate!

    func setContainerViewDelegate(containerViewDelegate: ContainerViewDelegate){
        self.containerViewDelegate = containerViewDelegate
    }

    func calculateAndSetMenuWidth(screenWidth: CGFloat) -> CGFloat {
        let percentageOfScreen: CGFloat = 0.85
        containerModel.menuWidth = screenWidth * percentageOfScreen
        return containerModel.menuWidth
    }

    func panDidEnd(translation: CGPoint, menuWidth: CGFloat) {
        if translation.x < containerModel.maxPanToOpen {
            containerModel.menuXDistance = 0
            self.containerViewDelegate.closeMenu(finishedAnimationFunction: nil, menuAnimationLength: containerModel.menuAnimationLength, menuWidth: containerModel.menuWidth)
        } else {
            containerModel.menuXDistance = menuWidth
            self.containerViewDelegate.openMenu(maxAlpha: containerModel.maxAlpha, menuAnimationLength: containerModel.menuAnimationLength)
        }
        containerModel.moved = false
    }

    func userHasPanned(translation: CGPoint, menuWidth: CGFloat) {
        let menuMoveDistance = containerModel.menuXDistance + translation.x
        if -containerModel.maxYForPan <= translation.y && translation.y <= containerModel.maxYForPan || containerModel.moved {
            if menuMoveDistance <= menuWidth {
                let xPosition = -containerModel.menuWidth + menuMoveDistance
                let alpha = calculateAlpha(menuMoveDistance: menuMoveDistance)
                containerViewDelegate.handleMenuMove(menuWidth: containerModel.menuWidth, alpha: alpha, xPosition: xPosition, menuAnimationLength: containerModel.menuAnimationLength)
                containerModel.moved = true
            }
        }

    }

    func calculateAlpha(menuMoveDistance: CGFloat) -> CGFloat {
        var percentageOfWidthMoved = menuMoveDistance / (containerModel.menuWidth / containerModel.maxAlpha)
        if percentageOfWidthMoved > containerModel.maxAlpha {
            percentageOfWidthMoved = containerModel.maxAlpha
        } else if percentageOfWidthMoved < 0 {
            percentageOfWidthMoved = 0
        }
        return percentageOfWidthMoved
    }



}

extension ContainerPresenter: MenuControllerDelegate {
    func handleMenuSelectOption(menuOptionSelected: MenuOptions) {
        containerViewDelegate.closeMenu(finishedAnimationFunction: { [unowned self] in
            self.containerViewDelegate.presentMenuOption(menuOptionSelected: menuOptionSelected)
        }, menuAnimationLength: containerModel.menuAnimationLength, menuWidth: containerModel.menuWidth)
    }

}

class ContainerController: UIViewController, ContainerViewDelegate {


    var menuController: MenuController!
    var homeController: HomeController!
    var backgroundController: BackgroundController?
    var panGestureRecognizer: UIPanGestureRecognizer!
    private let presenter = ContainerPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setContainerViewDelegate(containerViewDelegate: self)
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        let bounds = UIScreen.main.bounds
        let menuWidth = presenter.calculateAndSetMenuWidth(screenWidth: bounds.width)
        configureHomeController()
        configureMenuController(menuWidth: menuWidth, screenHeight: bounds.height)
        // todo: look into hidebaronswipe for swiping up to hide the nav bar
    }

    func configureHomeController() {
        homeController = HomeController()
        view.addSubview(homeController.view)
        addChild(homeController)
        homeController.didMove(toParent: self)
        // Todo: Use screen  edge pan recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        homeController.view.addGestureRecognizer(panGestureRecognizer)
    }

    func configureMenuController(menuWidth: CGFloat, screenHeight: CGFloat) {
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        menuController = MenuController(menuWidth: menuWidth, screenHeight: screenHeight)
        menuController.delegate = presenter
        currentWindow?.addSubview(menuController.view)
    }

    func handleMenuMove(menuWidth: CGFloat, alpha: CGFloat, xPosition: CGFloat, menuAnimationLength: Double) {
        self.addBackgroundController()
        self.animateMenu(xPosition: xPosition, alpha: alpha, menuAnimationLength: menuAnimationLength, finishedFunction: nil)
    }


    func addBackgroundController() {
        if backgroundController == nil {
            print("added background")
            backgroundController = BackgroundController()
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            currentWindow?.insertSubview(backgroundController!.view!, belowSubview: menuController.view)
            addChild(backgroundController!)
            backgroundController?.didMove(toParent: self)
        }
    }

    func removeBackgroundController() {
        guard let backgroundController = backgroundController else {
            return
        }
        print("removed background")
        backgroundController.willMove(toParent: nil)
        backgroundController.view.removeFromSuperview()
        backgroundController.removeFromParent()
        self.backgroundController = nil
    }

    func animateMenu(xPosition: CGFloat, alpha: CGFloat, menuAnimationLength: Double, finishedFunction: (() -> Void)?) {
        UIView.animate(withDuration: menuAnimationLength, animations: {
            self.menuController.view.frame.origin.x = xPosition
            self.backgroundController!.view.backgroundColor = UIColor(white: 0.3, alpha: alpha)
        }, completion: { (_) in
            if let function = finishedFunction {
                function()
            }
        })
    }


    func closeMenu(finishedAnimationFunction: (() -> Void)? = nil, menuAnimationLength: Double, menuWidth: CGFloat) {
        self.animateMenu(xPosition: -menuWidth, alpha: 0, menuAnimationLength: menuAnimationLength, finishedFunction: { () in
            if let finishedAnimationFunction = finishedAnimationFunction {
                finishedAnimationFunction()
            }
            self.homeController.view.addGestureRecognizer(self.panGestureRecognizer)
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            currentWindow?.removeGestureRecognizer(self.panGestureRecognizer)
        })
        // This has to be after the animateMenu function call because it uses the controller
        self.removeBackgroundController()
    }

    func openMenu(maxAlpha: CGFloat, menuAnimationLength: Double) {
        self.animateMenu(xPosition: 0, alpha: maxAlpha, menuAnimationLength: menuAnimationLength, finishedFunction: { () in
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

        if recognizer.state == UIGestureRecognizer.State.ended {
            presenter.panDidEnd(translation: translation, menuWidth: menuController.menuWidth)
        } else {
            presenter.userHasPanned(translation: translation, menuWidth: menuController.menuWidth)
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
            controller.modalPresentationStyle = .overCurrentContext
        }
        navigationController?.pushViewController(controller, animated: true)
    }


    deinit {
        print("deinit container controller")
    }

}



