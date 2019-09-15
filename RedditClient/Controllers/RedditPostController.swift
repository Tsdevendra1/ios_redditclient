//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

class RedditPostController: BaseViewController {

    var postInfo: PostAttributes

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupMainPostStack()
    }

    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var scoreLabel: UILabel!
    var commentsTotalLabel: UILabel!

    func setupMainPostStack(){
        let contentOverlay = UIView()
        contentOverlay.backgroundColor = .orange

        let contentStack = UIStackView(arrangedSubviews: [contentOverlay])

        view.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: navBar.bottomAnchor),
//            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentStack.leftAnchor.constraint(equalTo: view.leftAnchor)
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





}

