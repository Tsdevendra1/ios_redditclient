//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class RedditCommentCell: UITableViewCell {
    static let identifier = "RedditCommentCell"
    private var leftAnchorConstraint: NSLayoutConstraint!
    private var customContentView: UIView!
    private var leftContentConstraint: NSLayoutConstraint!

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

    override var indentationLevel: Int {
        didSet {
            leftContentConstraint.constant = CGFloat(indentationLevel) * indentationWidth
        }
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        customContentView = UIView()
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        customContentView.addSubview(descriptionLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: customContentView.centerYAnchor).isActive = true

        contentView.addSubview(customContentView)

        leftContentConstraint = customContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        leftContentConstraint.isActive = true

        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])


    }
}


