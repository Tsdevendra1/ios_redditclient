//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    let reuseIdentifier = "MenuCellView"

    let menuWidth: CGFloat = {
        let bounds = UIScreen.main.bounds
        let percentageOfScreen = 0.85
        return CGFloat(bounds.width * CGFloat(percentageOfScreen))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let bounds = UIScreen.main.bounds
        view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: bounds.height)
        self.tableView.register(MenuCellView.self, forCellReuseIdentifier: "MenuCellView")
    }


    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell’s contents.
        cell.textLabel!.text = "Cell text"

        return cell
    }

}
