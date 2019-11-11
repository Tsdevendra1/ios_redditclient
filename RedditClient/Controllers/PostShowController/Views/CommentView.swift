//
// Created by Tharuka Devendra on 2019-10-14.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

class CommentView: UIView {
    var commentLabel: UILabel!
    var commentIdentifierColor: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {

        backgroundColor = .white

        let seperator = addCustomSeparator(color: GlobalConfig.commentSeparatorColor!)

        commentIdentifierColor = UIView()
        addSubview(commentIdentifierColor)
        commentIdentifierColor.backgroundColor = .blue
        commentIdentifierColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentIdentifierColor.topAnchor.constraint(equalTo: topAnchor),
            commentIdentifierColor.leftAnchor.constraint(equalTo: leftAnchor),
            commentIdentifierColor.rightAnchor.constraint(equalTo: leftAnchor, constant: 4),
            commentIdentifierColor.bottomAnchor.constraint(equalTo: seperator.topAnchor),
        ])

        let actualContentView = UIView()

        actualContentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actualContentView)
        let padding: CGFloat = 6
        NSLayoutConstraint.activate([
            actualContentView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            actualContentView.bottomAnchor.constraint(equalTo: seperator.topAnchor, constant: -padding),
            actualContentView.leftAnchor.constraint(equalTo: commentIdentifierColor.rightAnchor, constant: padding),
            actualContentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
        ])

        commentLabel = UILabel()
        commentLabel.textColor = .black
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byWordWrapping
        commentLabel.font = .systemFont(ofSize: 16)
        commentLabel.text = "Placeholder"
        actualContentView.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.leftAnchor.constraint(equalTo: actualContentView.leftAnchor).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: actualContentView.rightAnchor).isActive = true
        commentLabel.topAnchor.constraint(equalTo: actualContentView.topAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: actualContentView.bottomAnchor).isActive = true

    }


}
