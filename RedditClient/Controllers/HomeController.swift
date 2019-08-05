//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var delegate: HomeControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        configureToggleMenuButton()
    }

    func configureToggleMenuButton(){
        let button = UIButton()
        button.titleLabel?.text = "Toggle"
        button.backgroundColor = .red
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(handleMenuToggle), for: .touchUpInside)
    }

    @objc func handleMenuToggle(){
        delegate?.handleMenuToggle()
    }


}
