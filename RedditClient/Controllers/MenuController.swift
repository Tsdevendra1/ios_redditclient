//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: class {
    var delegate: MenuControllerDelegate! {get set}
}

class MenuModel {
    var lastY: CGFloat = 0
    var usernameHeight: CGFloat = 130
    var defaultHeight: CGFloat = 55
    var menuWidth: CGFloat!
}

class MenuPresenter {
    private let menuModel = MenuModel()
    unowned var menuViewDelegate: MenuViewDelegate!

    func calculateAndSetMenuWidth(screenWidth: CGFloat) -> CGFloat {
        let percentageOfScreen: CGFloat = 0.85
        menuModel.menuWidth = screenWidth * percentageOfScreen
        return menuModel.menuWidth
    }

    func getHeightForRow(row: Int) -> CGFloat {
        let menuOption = MenuOptions(rawValue: row)
        if menuOption == .UserName {
            return menuModel.usernameHeight
        }
        return menuModel.defaultHeight
    }

    func handleRowWasSelected(row: Int) {
        let menuOption = MenuOptions(rawValue: row)
        if let menuOptionSelected = menuOption {
            menuViewDelegate.delegate.handleMenuSelectOption(menuOptionSelected: menuOptionSelected)
        }
    }
}

class MenuController: UITableViewController, MenuViewDelegate {
    unowned var delegate: MenuControllerDelegate!
    private let presenter = MenuPresenter()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        let bounds = UIScreen.main.bounds
        let menuWidth = presenter.calculateAndSetMenuWidth(screenWidth: bounds.width)
        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = .white
        self.tableView.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: bounds.height)
        setViewSettingWithBgShade(view: self.tableView)
        self.tableView.register(MenuCellView.self, forCellReuseIdentifier: MenuCellView.identifier)
        self.tableView.register(HeaderMenuCellView.self, forCellReuseIdentifier: HeaderMenuCellView.identifier)
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false

    }

    public func setViewSettingWithBgShade(view: UIView) {
        //MARK:- Shade a view
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
    }

//
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.alwaysBounceVertical = false
    }


    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.getHeightForRow(row: indexPath.row)
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let menuOption = MenuOptions(rawValue: indexPath.row)


        // Configure the cell’s contents.
        if menuOption == .UserName {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderMenuCellView.identifier, for: indexPath) as! HeaderMenuCellView
            cell.descriptionLabel.text = menuOption?.description
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: cell.frame.maxY - 1, width: cell.frame.width, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.layer.addSublayer(bottomBorder)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellView.identifier, for: indexPath) as! MenuCellView
            cell.descriptionLabel.text = menuOption?.description
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.handleRowWasSelected(row:indexPath.row)
    }

    deinit {
        print("deinit menucontroller")
    }
}
