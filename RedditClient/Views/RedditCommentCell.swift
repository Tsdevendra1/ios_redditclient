//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class RedditCommentCell: UITableViewCell {
    static let identifier = "RedditCommentCell"

    // todo: use layoutsubviews or something when the margins change?
    var topInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var rightInset: CGFloat = 0
    var leftAnchorConstraint: NSLayoutConstraint!

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
            leftAnchorConstraint.constant = 100
            super.layoutSubviews()
        }
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        leftAnchorConstraint = descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor)
        leftAnchorConstraint.isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}


