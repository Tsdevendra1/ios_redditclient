//
// Created by Tharuka Devendra on 2019-10-12.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addCustomSeparator(color: UIColor) -> UIView {
        let seperator = UIView()
        self.addSubview(seperator)
        seperator.backgroundColor = color
        seperator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            seperator.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            seperator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            seperator.leftAnchor.constraint(equalTo: self.leftAnchor),
            seperator.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
        return seperator
    }
}