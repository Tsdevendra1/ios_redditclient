//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class RedditCommentCell: UITableViewCell {
    static let identifier = "RedditCommentCell"
    private var leftAnchorConstraint: NSLayoutConstraint!
    private var customContentView: UIView!
    private var leftContentConstaint: NSLayoutConstraint!

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
            print("did set")
            leftContentConstaint.constant = CGFloat(indentationLevel) * indentationWidth
        }
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        customContentView = UIView()
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        customContentView.addSubview(descriptionLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: customContentView.centerYAnchor).isActive = true

        contentView.addSubview(customContentView)

        leftContentConstaint = customContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        leftContentConstaint.isActive = true

        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])


    }
}


