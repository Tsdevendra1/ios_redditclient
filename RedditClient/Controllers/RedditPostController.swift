//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

protocol RedditPostViewDelegate: class {

}

class RedditPostPresenter {
    unowned private var redditPostViewDelegate: RedditPostViewDelegate!

    func setRedditPostViewDelegate(delegate: RedditPostViewDelegate) {
        self.redditPostViewDelegate = delegate
    }
}

extension RedditPostPresenter: HandlesPostButtonClickDelegate {

    func handleUpvoteClick() {
    }

    func handleDownvoteClick() {
    }

    func handleFavouriteClick() {
    }

    func handleMoreClick() {
    }

}

class RedditPostController: BaseViewController, RedditPostViewDelegate {

    var postInfo: PostAttributes
    private let presenter = RedditPostPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setRedditPostViewDelegate(delegate: self)
        view.backgroundColor = .white
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let contentStack = RedditPostView(postAttributes: postInfo, frame: rect)
        contentStack.delegate = presenter
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


    deinit {
        print("deinit redditPostController")
    }

}

