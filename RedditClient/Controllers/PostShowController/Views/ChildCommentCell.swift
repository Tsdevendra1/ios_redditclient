//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class ChildCommentCell: UITableViewCell {
    static let identifier = "RedditCommentCell"
    private var leftContentConstraint: NSLayoutConstraint!
    var commentView: CommentView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override var indentationLevel: Int {
        didSet {
            leftContentConstraint.constant = CGFloat(indentationLevel) * indentationWidth
        }
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        commentView = CommentView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            commentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])

        leftContentConstraint = commentView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        leftContentConstraint.isActive = true


    }
}


