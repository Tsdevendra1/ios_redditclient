//
// Created by Tharuka Devendra on 2019-09-25.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

class ParentCommentCell: UITableViewHeaderFooterView {
    static let identifier = "RedditPostHeaderView"
    var section: Int!
    var commentIdentifierColor: UIView!
    unowned var delegate: ParentCommentDelegate!

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.text = "Testing"
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBackgroundView()
    }

    func setupBackgroundView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)

        let seperator = view.addCustomSeparator(color: .red)

        commentIdentifierColor = UIView()
        view.addSubview(commentIdentifierColor)
        commentIdentifierColor.backgroundColor = .blue
        commentIdentifierColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentIdentifierColor.topAnchor.constraint(equalTo: view.topAnchor),
            commentIdentifierColor.leftAnchor.constraint(equalTo: view.leftAnchor),
            commentIdentifierColor.rightAnchor.constraint(equalTo: view.leftAnchor, constant: 3),
            commentIdentifierColor.bottomAnchor.constraint(equalTo: seperator.topAnchor),
        ])

        let contentView = UIView()
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: seperator.topAnchor),
            contentView.leftAnchor.constraint(equalTo: commentIdentifierColor.rightAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        backgroundView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapHeader(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.toggleSection(header: self, section: section)
    }
}


