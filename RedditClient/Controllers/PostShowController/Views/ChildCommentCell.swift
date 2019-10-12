//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class ChildCommentCell: UITableViewCell {
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        contentView.addSubview(customContentView)

        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])

        leftContentConstraint = customContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        leftContentConstraint.isActive = true
        customContentView.backgroundColor = .white
        customContentView.translatesAutoresizingMaskIntoConstraints = false

        let seperator = customContentView.addCustomSeparator(color: .red)

        let actualContentView = UIView()
        actualContentView.translatesAutoresizingMaskIntoConstraints = false
        customContentView.addSubview(actualContentView)
        NSLayoutConstraint.activate([
            actualContentView.topAnchor.constraint(equalTo: customContentView.topAnchor),
            actualContentView.bottomAnchor.constraint(equalTo: seperator.topAnchor),
            actualContentView.leftAnchor.constraint(equalTo: customContentView.leftAnchor),
            actualContentView.rightAnchor.constraint(equalTo: customContentView.rightAnchor),
        ])

        actualContentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: actualContentView.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: actualContentView.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: actualContentView.topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: actualContentView.bottomAnchor).isActive = true
    }
}


