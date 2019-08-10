//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    let reuseIdentifier = "MenuCellView"
    var lastY: CGFloat = 0

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
        self.tableView.register(MenuCellView.self, forCellReuseIdentifier: "MenuCellView")
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

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let menuOption = MenuOptions(rawValue: indexPath.row)
        // Configure the cell’s contents.
        cell.textLabel!.text = menuOption?.description

        return cell
    }

}
