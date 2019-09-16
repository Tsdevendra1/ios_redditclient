//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate {
    func handlePanGesture(recognizer: UIPanGestureRecognizer)
}

protocol MenuControllerDelegate: class {
    func handleMenuSelectOption(menuOptionSelected: MenuOptions)
}

protocol RedditPostLayout {
    var titleLabel: UILabel! {get set}
    var authorLabel: UILabel! {get set}
    var commentsTotalLabel: UILabel! {get set}
    var scoreLabel: UILabel! {get set}
    var upvoteButton: UIButton! {get set}
    var downvoteButton: UIButton! {get set}
    var favouriteButton: UIButton! {get set}
    var moreButton: UIButton! {get set}
}


@objc protocol HandlesPostButtonClicks {
    func handleMoreClick(sender: UIButton)
    func handleUpvoteClick(sender: UIButton)
    func handleDownvoteClick(sender: UIButton)
    func handleFavouriteClick(sender: UIButton)

}