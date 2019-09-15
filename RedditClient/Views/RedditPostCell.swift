//
// Created by Tharuka Devendra on 2019-09-07.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit
import Foundation

class RedditPostCell: UITableViewCell {


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

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    let commentsTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()





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

        configureContentStack(view: contentOverlay)

    }

    @objc func handleUpvoteClick(sender: UIButton) {
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
    @objc func handleDownvoteClick(sender: UIButton) {
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

    @objc func handleFavouriteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @objc func handleMoreClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    func createBasicLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }


    func createButtonsArray() -> [UIButton] {


        upvoteButton = UIButton()
        let upvoteDefaultImage = UIImage(named: "star")!
        let upvoteSelectedImage = UIImage(named: "star_upvote")!
        upvoteButton.setImage(upvoteDefaultImage, for: .normal)
        upvoteButton.setImage(upvoteSelectedImage, for: .selected)
        upvoteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

        downvoteButton = UIButton()
        let downvoteDefaultImage = UIImage(named: "star")!
        let downvoteSelectedImage = UIImage(named: "star_upvote")!
        downvoteButton.setImage(downvoteDefaultImage, for: .normal)
        downvoteButton.setImage(downvoteSelectedImage, for: .selected)
        downvoteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

        favouriteButton = UIButton()
        let favouriteDefaultImage = UIImage(named: "star")!
        let favouriteSelectedImage = UIImage(named: "star_upvote")!
        favouriteButton.setImage(favouriteDefaultImage, for: .normal)
        favouriteButton.setImage(favouriteSelectedImage, for: .selected)
        favouriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

        moreButton = UIButton()
        let moreDefaultImage = UIImage(named: "star")!
        let moreSelectedImage = UIImage(named: "star_upvote")!
        moreButton.setImage(moreDefaultImage, for: .normal)
        moreButton.setImage(moreSelectedImage, for: .selected)
        moreButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let buttonArray: [UIButton] = [upvoteButton, downvoteButton, favouriteButton, moreButton]

        return buttonArray

    }

    func createButtonsArrayWithTarget() -> [UIButton] {
        let buttonArray = createButtonsArray()
        buttonArray[0].addTarget(self, action: #selector(handleUpvoteClick), for: .touchUpInside)
        buttonArray[1].addTarget(self, action: #selector(handleDownvoteClick), for: .touchUpInside)
        buttonArray[2].addTarget(self, action: #selector(handleFavouriteClick), for: .touchUpInside)
        buttonArray[3].addTarget(self, action: #selector(handleMoreClick), for: .touchUpInside)
        return buttonArray
    }

    func configureBottomRow() -> UIView {

        let view = UIView()
        view.backgroundColor = .white
        let scoreAndCommentsStack = UIStackView(arrangedSubviews: [scoreLabel, commentsTotalLabel])
        scoreAndCommentsStack.axis = .vertical
        view.addSubview(scoreAndCommentsStack)
        scoreAndCommentsStack.translatesAutoresizingMaskIntoConstraints = false
        scoreAndCommentsStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scoreAndCommentsStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scoreAndCommentsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true


        let cellButtons = createButtonsArrayWithTarget()
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

    func createInterPunctLabel() -> UILabel {
        let label = UILabel()
        label.text = " · "
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
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


}
