//
// Created by Tharuka Devendra on 2019-09-20.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

@objc protocol HandlesPostButtonClickDelegate {
    func handleMoreClick()
    func handleUpvoteClick()
    func handleDownvoteClick()
    func handleFavouriteClick()
}

protocol RedditViewDelegate: class {
    func configureContentStack()
    func setupLabelAttributes(postText: RedditPostTextData)
    func turnOnUpvote()
    func turnOnDownvote()
    func turnOnMore()
    func turnOnFavourite()
    var upvoteButton: UIButton {get}
    var downvoteButton: UIButton {get}
    var favouriteButton: UIButton {get}
    var moreButton: UIButton {get}
}

struct RedditPostTextData {
    let authorText: NSMutableAttributedString
    let scoreText: String
    let commentsTotalText: String
    let titleText: String
}


class RedditPostViewModel {
    var postAttributes: PostAttributes!
}

class RedditViewPresenter {
    private let redditPostViewModel = RedditPostViewModel()
    unowned private var redditViewDelegate: RedditViewDelegate!

    func setRedditViewDelegate(delegate: RedditViewDelegate) {
        self.redditViewDelegate = delegate
    }

    func setPostAttributes(postAttributes: PostAttributes) {
        redditPostViewModel.postAttributes = postAttributes
    }

    func handleCellWasReused() {
        // todo: FIll this and call it when the cell is reused
    }

    func setLabelAttributes() {
        let labelsText = createRedditPostText(cellData: redditPostViewModel.postAttributes)
        redditViewDelegate.setupLabelAttributes(postText: labelsText)
    }

    func configureContentStack() {
        redditViewDelegate.configureContentStack()
    }

    func createRedditPostText(cellData: PostAttributes) -> RedditPostTextData {
        let hoursSincePost = getTimeSincePostInHours(cellData.createdUtc)
        return RedditPostTextData(
                authorText: createAuthorLabelWithTimeAndSubredditText(hoursSincePost: hoursSincePost,
                        subreddit: cellData.subreddit.lowercased(), author: cellData.author),
                scoreText: createPostPointsText(score: cellData.score),
                commentsTotalText: createPostCommentsText(numComments: cellData.numComments),
                titleText: cellData.title
        )
    }

    func getButtonStates() -> [String: Bool] {
        return ["upvote": redditViewDelegate.upvoteButton.isSelected,
                "downvote": redditViewDelegate.downvoteButton.isSelected,
                "more": redditViewDelegate.moreButton.isSelected,
                "favorite": redditViewDelegate.favouriteButton.isSelected]
    }

    func configurePostIfButtonSelected(buttonStates: [String: Bool]) {

        let buttonFunctions = ["upvote": redditViewDelegate.turnOnUpvote, "downvote": redditViewDelegate.turnOnDownvote, "more": redditViewDelegate.turnOnMore,
                               "favorite": redditViewDelegate.turnOnFavourite]

        for (buttonType, buttonIsSelected) in buttonStates {
            if buttonIsSelected {
                if let function = buttonFunctions[buttonType]{
                    function()
                }
            }
        }


    }
}

class RedditPostView: UIView, RedditViewDelegate {


    let upvoteButton = UIButton()
    let downvoteButton = UIButton()
    let favouriteButton = UIButton()
    let moreButton = UIButton()
    var delegate: HandlesPostButtonClickDelegate?
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let scoreLabel = UILabel()
    let commentsTotalLabel = UILabel()
    var presenter = RedditViewPresenter()


    init(postAttributes: PostAttributes? = nil, frame: CGRect) {
        super.init(frame: frame)
        presenter.setRedditViewDelegate(delegate: self)
        if let postAttributes = postAttributes {
            presenter.setPostAttributes(postAttributes: postAttributes)
            presenter.setLabelAttributes()
        }
        presenter.configureContentStack()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func turnOnUpvote() {
        downvoteButton.isSelected = false
        scoreLabel.textColor = .orange
        upvoteButton.isSelected = true
    }

    func turnOnDownvote() {
        upvoteButton.isSelected = false
        scoreLabel.textColor = .blue
        downvoteButton.isSelected = true
    }

    func turnOnMore() {
        moreButton.isSelected = true
    }

    func turnOnFavourite() {
        favouriteButton.isSelected = true
    }

    @objc func handleUpvoteClick() {
        upvoteButton.isSelected = !upvoteButton.isSelected

        if upvoteButton.isSelected {
            turnOnUpvote()
        } else {
            scoreLabel.textColor = .black
        }
        delegate?.handleUpvoteClick()
    }

    @objc func handleDownvoteClick() {
        downvoteButton.isSelected = !downvoteButton.isSelected

        if downvoteButton.isSelected {
            turnOnDownvote()
        } else {
            scoreLabel.textColor = .black
        }
        delegate?.handleDownvoteClick()
    }

    @objc func handleFavouriteClick() {
        favouriteButton.isSelected = !favouriteButton.isSelected
        delegate?.handleFavouriteClick()
    }

    @objc func handleMoreClick() {
        moreButton.isSelected = !moreButton.isSelected
        delegate?.handleMoreClick()
    }

    func createButtonsArray() -> [UIButton] {


        let buttonArray: [UIButton] = [upvoteButton, downvoteButton, favouriteButton, moreButton]
        let selectors: [Selector] = [#selector(handleUpvoteClick), #selector(handleDownvoteClick), #selector(handleFavouriteClick), #selector(handleMoreClick)]
        for (index, button) in buttonArray.enumerated() {
            let upvoteDefaultImage = UIImage(named: "star")!
            let upvoteSelectedImage = UIImage(named: "star_upvote")!
            button.setImage(upvoteDefaultImage, for: .normal)
            button.setImage(upvoteSelectedImage, for: .selected)
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.addTarget(self, action: selectors[index], for: .touchUpInside)
        }


        return buttonArray

    }

    func configureBottomRow(_ commentAndScoreLabels: [UILabel]) -> UIView {

        let bottomRowOverlayView = UIView()
        bottomRowOverlayView.backgroundColor = .white

        let scoreAndCommentsStack = UIStackView(arrangedSubviews: commentAndScoreLabels)
        scoreAndCommentsStack.axis = .vertical
        bottomRowOverlayView.addSubview(scoreAndCommentsStack)
        scoreAndCommentsStack.translatesAutoresizingMaskIntoConstraints = false
        scoreAndCommentsStack.leftAnchor.constraint(equalTo: bottomRowOverlayView.leftAnchor).isActive = true
        scoreAndCommentsStack.topAnchor.constraint(equalTo: bottomRowOverlayView.topAnchor).isActive = true
        scoreAndCommentsStack.bottomAnchor.constraint(equalTo: bottomRowOverlayView.bottomAnchor).isActive = true


        let cellButtons = createButtonsArray()
        let buttonStack = UIStackView(arrangedSubviews: cellButtons)
        // just an arbitrary number
        buttonStack.spacing = 7
        buttonStack.axis = .horizontal

        buttonStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bottomRowOverlayView.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.rightAnchor.constraint(equalTo: bottomRowOverlayView.rightAnchor).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: bottomRowOverlayView.centerYAnchor).isActive = true

        return bottomRowOverlayView
    }


    func createRedditPostText(cellData: PostAttributes) -> RedditPostTextData {
        let hoursSincePost = getTimeSincePostInHours(cellData.createdUtc)
        return RedditPostTextData(
                authorText: createAuthorLabelWithTimeAndSubredditText(hoursSincePost: hoursSincePost,
                        subreddit: cellData.subreddit.lowercased(), author: cellData.author),
                scoreText: createPostPointsText(score: cellData.score),
                commentsTotalText: createPostCommentsText(numComments: cellData.numComments),
                titleText: cellData.title
        )
    }

    func setupLabelAttributes(postText: RedditPostTextData) {
        titleLabel.text = postText.titleText
        authorLabel.attributedText = postText.authorText
        scoreLabel.text = postText.scoreText
        commentsTotalLabel.text = postText.commentsTotalText

        titleLabel.textColor = .black
        authorLabel.textColor = .black
        scoreLabel.textColor = .black
        commentsTotalLabel.textColor = .black
        titleLabel.numberOfLines = 0
        authorLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        authorLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = .systemFont(ofSize: 20)
        authorLabel.font = .systemFont(ofSize: 14)
        scoreLabel.font = .systemFont(ofSize: 14)
        commentsTotalLabel.font = .systemFont(ofSize: 14)
    }

    func configureContentStack() {

        let bottomRow = configureBottomRow([scoreLabel, commentsTotalLabel])

        let stackedViews: [UIView] = [titleLabel, authorLabel, bottomRow]

        let contentStack = UIStackView(arrangedSubviews: stackedViews)
        contentStack.axis = .vertical
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

    }
}
