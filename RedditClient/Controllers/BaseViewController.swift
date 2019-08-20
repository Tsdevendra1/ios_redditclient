//
// Created by Tharuka Devendra on 2019-08-20.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit


class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        print("hi")
    }

    func setupNavBar() {
        fatalError("Must override")
    }

}
