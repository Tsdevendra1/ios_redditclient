//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

class RedditPostController: BaseViewController {

    var subreddit: String

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

    init(subreddit: String) {
        self.subreddit = subreddit
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createNavbarItem() -> UINavigationItem {
        let item = UINavigationItem()
        item.title = subreddit
        let button = UIButton()
        button.setTitle("backbutton", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(dismissPresentedView), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: button)
        item.leftBarButtonItems = [backBarButton]
        return item
    }


    @objc func dismissPresentedView(){
        self.dismiss(animated: true)
    }



}

