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
    var associatedCell: RedditPostCell!
    unowned var delegate: HandlesPostButtonClicks!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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


    deinit {
        print("deinit redditPostController")
    }

}

