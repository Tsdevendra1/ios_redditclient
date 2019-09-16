//
// Created by Tharuka Devendra on 2019-09-07.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit
import Foundation

class RedditPostCell: UITableViewCell, RedditPostLayout, HandlesPostButtonClicks {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static let identifier = "RedditPostCell"
    var upvoteButton: UIButton!
    var downvoteButton: UIButton!
    var favouriteButton: UIButton!
    var moreButton: UIButton!
    var contentOverlay: UIView!
    var subreddit: String!
    var rowNumber: Int!
    var postId: String!
    var stateController: StateController!

    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var scoreLabel: UILabel!
    var commentsTotalLabel: UILabel!

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // make the base layer transparent
        backgroundColor = UIColor(white: 1, alpha: 0)

        // This is the white background of the cell
        contentOverlay = UIView()
        addSubview(contentOverlay)
        contentOverlay.backgroundColor = .white
        contentOverlay.layer.cornerRadius = 10
        contentOverlay.layer.masksToBounds = true

        contentOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentOverlay.leftAnchor.constraint(equalTo: leftAnchor),
            contentOverlay.rightAnchor.constraint(equalTo: rightAnchor),
            // remember downward is positive and right is positive. need to divide by two because otherwise we are
            // padding each cell twice (one from the cell and then another from the cell below and above)
            contentOverlay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(HomeController.cellPadding) / 2),
            contentOverlay.topAnchor.constraint(equalTo: topAnchor, constant: (HomeController.cellPadding) / 2)
        ])

//        configureContentStack(view: contentOverlay)
        let contentStack = configureContentStack_(target: self)
        scoreLabel.text = "ewq"
        commentsTotalLabel.text = "ewq"
        authorLabel.text = "ewq"
        titleLabel.text = "ewq"

        contentOverlay.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 12
        contentStack.topAnchor.constraint(equalTo: contentOverlay.topAnchor, constant: padding).isActive = true
        contentStack.bottomAnchor.constraint(equalTo: contentOverlay.bottomAnchor, constant: -padding).isActive = true
        contentStack.rightAnchor.constraint(equalTo: contentOverlay.rightAnchor, constant: -padding).isActive = true
        contentStack.leftAnchor.constraint(equalTo: contentOverlay.leftAnchor, constant: padding).isActive = true
    }

    func handleUpvoteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            stateController.postState[postId] = PostState.upvoted
            downvoteButton.isSelected = false
            scoreLabel.textColor = .orange
        } else {
            stateController.postState[postId] = PostState.none
            scoreLabel.textColor = .black
        }

    }

    func handleDownvoteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            stateController.postState[postId] = PostState.downvoted
            upvoteButton.isSelected = false
            scoreLabel.textColor = .blue
        } else {
            stateController.postState[postId] = PostState.none
            scoreLabel.textColor = .black
        }
    }

    func handleFavouriteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    func handleMoreClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }


}
