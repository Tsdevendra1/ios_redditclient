//
// Created by Tharuka Devendra on 2019-09-25.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

class ParentCommentCell: UITableViewHeaderFooterView {
    static let identifier = "RedditPostHeaderView"
    var section: Int!
    var commentView: CommentView!
    unowned var delegate: ParentCommentDelegate!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBackgroundView()
    }

    func setupBackgroundView() {
        commentView = CommentView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))

        backgroundView = commentView

        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        commentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        commentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        commentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapHeader(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.toggleSection(header: self, section: section)
    }
}


