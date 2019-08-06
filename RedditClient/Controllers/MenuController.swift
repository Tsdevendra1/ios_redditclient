//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    let menuWidth = CGFloat(89)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        let bounds = UIScreen.main.bounds
        view.frame = CGRect(x:-menuWidth, y: 0, width: menuWidth, height: bounds.height)
    }



}
