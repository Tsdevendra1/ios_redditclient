//
// Created by Tharuka Devendra on 2019-08-15.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

class HeaderMenuCellView: UITableViewCell {
    static let identifier = "HeaderMenuCellViewCell"

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.text = "Testing"
        return label
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true

        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.maxY, width: frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(bottomBorder)
    }
}


