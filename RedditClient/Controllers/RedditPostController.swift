//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

class RedditPostController: BaseViewController, RedditPostLayout, HandlesPostButtonClicks {

    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var commentsTotalLabel: UILabel!
    var scoreLabel: UILabel!
    var postInfo: PostAttributes
    var upvoteButton: UIButton!
    var downvoteButton: UIButton!
    var moreButton: UIButton!
    var favouriteButton: UIButton!
    var contentStack: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setupMainPostStack()
//        let contentStack = configureContentStack_(target: self)
//        scoreLabel.text = "ewq"
//        commentsTotalLabel.text = "ewq"
//        authorLabel.text = "ewq"
//        titleLabel.text = "ewq"
        view.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            contentStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            contentStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
    }

//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 20)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        return label
//    }()
//
//    let authorLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 14)
//        return label
//    }()
//
//    let scoreLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 14)
//        return label
//    }()
//
//    let commentsTotalLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 14)
//        return label
//    }()


    func setupMainPostStack() {

        titleLabel.text = postInfo.title
        scoreLabel.text = createPostPointsText(score: postInfo.score)
        commentsTotalLabel.text = createPostCommentsText(numComments: postInfo.numComments)
        let hoursSincePost = getTimeSincePostInHours(postInfo.createdUtc)
        authorLabel.attributedText = createAuthorLabelWithTimeAndSubredditText(hoursSincePost: hoursSincePost, subreddit: postInfo.subreddit, author: postInfo.author)
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, scoreLabel, commentsTotalLabel])
        contentStack.backgroundColor = .white
        contentStack.axis = .vertical

        view.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            contentStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            contentStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
    }

    init(infoForPost: PostAttributes) {
        self.postInfo = infoForPost
        super.init(nibName: nil, bundle: nil)
        contentStack = configureContentStack_(target: self)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createNavbarItem() -> UINavigationItem {
        let item = UINavigationItem()
        item.title = postInfo.subreddit
        let button = UIButton()
        button.setTitle("backbutton", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: button)
        item.leftBarButtonItems = [backBarButton]
        return item
    }

    func handleUpvoteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            downvoteButton.isSelected = false
            scoreLabel.textColor = .orange
        } else {
            scoreLabel.textColor = .black
        }

    }

    func handleDownvoteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            upvoteButton.isSelected = false
            scoreLabel.textColor = .blue
        } else {
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
