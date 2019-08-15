//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    var lastY: CGFloat = 0
    var usernameHeight: CGFloat = 130
    var defaultHeight: CGFloat = 55
    var delegate: MenuControllerDelegate!

    let menuWidth: CGFloat = {
        let bounds = UIScreen.main.bounds
        let percentageOfScreen = 0.85
        return CGFloat(bounds.width * CGFloat(percentageOfScreen))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = .white
        let bounds = UIScreen.main.bounds
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
        let menuOption = MenuOptions(rawValue: indexPath.row)
        if menuOption == .UserName {
            return usernameHeight
        } else {
            return defaultHeight
        }
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let menuOption = MenuOptions(rawValue: indexPath.row)


        // Configure the cell’s contents.
        if menuOption == .UserName {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderMenuCellView.identifier, for: indexPath) as! HeaderMenuCellView
            cell.descriptionLabel.text = menuOption?.description
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellView.identifier, for: indexPath) as! MenuCellView
            cell.descriptionLabel.text = menuOption?.description
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOptions(rawValue: indexPath.row)
        if let menuOptionSelected = menuOption {
            delegate.handleMenuSelectOption(menuOptionSelected: menuOptionSelected)
        }
    }

}
