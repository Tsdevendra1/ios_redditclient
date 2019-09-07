//
// Created by Tharuka Devendra on 2019-09-07.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit
import Foundation

class RedditPostCell: UITableViewCell {
    static let identifier = "RedditPostCell"
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let descriptionLabel: UILabel  = {
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
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
