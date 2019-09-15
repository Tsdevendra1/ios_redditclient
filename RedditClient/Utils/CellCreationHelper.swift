//
// Created by Tharuka Devendra on 2019-09-15.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

func createButtonsArray(target: RedditPostCell) -> [UIButton] {


    let upvoteButton = UIButton()
    let upvoteDefaultImage = UIImage(named: "star")!
    let upvoteSelectedImage = UIImage(named: "star_upvote")!
    upvoteButton.setImage(upvoteDefaultImage, for: .normal)
    upvoteButton.setImage(upvoteSelectedImage, for: .selected)
    upvoteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

    let downvoteButton = UIButton()
    let downvoteDefaultImage = UIImage(named: "star")!
    let downvoteSelectedImage = UIImage(named: "star_upvote")!
    downvoteButton.setImage(downvoteDefaultImage, for: .normal)
    downvoteButton.setImage(downvoteSelectedImage, for: .selected)
    downvoteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

    let favouriteButton = UIButton()
    let favouriteDefaultImage = UIImage(named: "star")!
    let favouriteSelectedImage = UIImage(named: "star_upvote")!
    favouriteButton.setImage(favouriteDefaultImage, for: .normal)
    favouriteButton.setImage(favouriteSelectedImage, for: .selected)
    favouriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

    let moreButton = UIButton()
    let moreDefaultImage = UIImage(named: "star")!
    let moreSelectedImage = UIImage(named: "star_upvote")!
    moreButton.setImage(moreDefaultImage, for: .normal)
    moreButton.setImage(moreSelectedImage, for: .selected)
    moreButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

    let buttonArray: [UIButton] = [upvoteButton, downvoteButton, favouriteButton, moreButton]

    target.upvoteButton = upvoteButton
    target.moreButton = moreButton
    target.downvoteButton = downvoteButton
    target.favouriteButton = favouriteButton


    return buttonArray

}

func createButtonsArrayWithTarget(target: RedditPostCell) -> [UIButton] {
    let buttonArray = createButtonsArray(target: target)
    buttonArray[0].addTarget(target, action: #selector(target.handleUpvoteClick), for: .touchUpInside)
    buttonArray[1].addTarget(target, action: #selector(target.handleDownvoteClick), for: .touchUpInside)
    buttonArray[2].addTarget(target, action: #selector(target.handleFavouriteClick), for: .touchUpInside)
    buttonArray[3].addTarget(target, action: #selector(target.handleMoreClick), for: .touchUpInside)
    return buttonArray
}

func configureBottomRow(target: RedditPostCell) -> UIView {

    let view = UIView()
    view.backgroundColor = .white
    let scoreAndCommentsStack = UIStackView(arrangedSubviews: [scoreLabel, commentsTotalLabel])
    scoreAndCommentsStack.axis = .vertical
    view.addSubview(scoreAndCommentsStack)
    scoreAndCommentsStack.translatesAutoresizingMaskIntoConstraints = false
    scoreAndCommentsStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    scoreAndCommentsStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scoreAndCommentsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true


    let cellButtons = createButtonsArrayWithTarget(target: target)
    let buttonStack = UIStackView(arrangedSubviews: cellButtons)
    // just an arbitrary number
    buttonStack.spacing = 7
    buttonStack.axis = .horizontal

    buttonStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
    view.addSubview(buttonStack)
    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    buttonStack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    return view

}
func configureContentStack(view: UIView) {

    let bottomRow = configureBottomRow()
    let stackedViews: [UIView] = [titleLabel, authorLabel, bottomRow]

    let contentStack = UIStackView(arrangedSubviews: stackedViews)
    contentStack.axis = .vertical

    view.addSubview(contentStack)

    contentStack.translatesAutoresizingMaskIntoConstraints = false
    let padding: CGFloat = 12
    contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
    contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
    contentStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true
    contentStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
}
