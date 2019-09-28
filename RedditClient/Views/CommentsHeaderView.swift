//
// Created by Tharuka Devendra on 2019-09-25.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

class CommentsHeaderView: UITableViewHeaderFooterView {
    static let identifier = "RedditPostHeaderView"
    var commentTree: CommentChain!
    var section: Int!
    unowned var delegate: HeaderViewDelegate!


    @objc func didTapHeader(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.toggleSection(header: self, section: section)
    }
}


