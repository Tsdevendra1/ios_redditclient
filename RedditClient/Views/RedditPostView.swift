//
// Created by Tharuka Devendra on 2019-09-20.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//
@objc protocol HandlesPostButtonClickDelegate {
    func handleMoreClick()
    func handleUpvoteClick()
    func handleDownvoteClick()
    func handleFavouriteClick()
}

protocol RedditViewDelegate: class {
    func configureContentStack()
    func setupLabelAttributes(postText: RedditPostTextData)
}

struct RedditPostTextData {
    let authorText: NSMutableAttributedString
    let scoreText: String
    let commentsTotalText: String
    let titleText: String
}

import Foundation

import UIKit

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
}

class RedditPostView: UIView, RedditViewDelegate {

    let upvoteButton = UIButton()
    let downvoteButton = UIButton()
    let favouriteButton = UIButton()
    let moreButton = UIButton()
    var delegate: HandlesPostButtonClickDelegate!
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

    @objc func handleUpvoteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            downvoteButton.isSelected = false
            scoreLabel.textColor = .orange
        } else {
            scoreLabel.textColor = .black
        }
        delegate.handleUpvoteClick()
    }

    @objc func handleDownvoteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            upvoteButton.isSelected = false
            scoreLabel.textColor = .blue
        } else {
            scoreLabel.textColor = .black
        }
        delegate.handleDownvoteClick()
    }

    @objc func handleFavouriteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate.handleFavouriteClick()
    }

    @objc func handleMoreClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate.handleMoreClick()
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
