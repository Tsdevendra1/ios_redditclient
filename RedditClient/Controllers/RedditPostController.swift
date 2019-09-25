//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit


protocol RedditPostViewDelegate: class {
    var ownPostButtonClickedDelegate: RedditPostCell! { get set }
    func setupCommentsTableView()
}

class RedditPostPresenter {

    unowned private var redditPostViewDelegate: RedditPostViewDelegate!

    func setRedditPostViewDelegate(delegate: RedditPostViewDelegate) {
        self.redditPostViewDelegate = delegate
    }

    func setupCommentsView() {
        redditPostViewDelegate.setupCommentsTableView()
    }
}


class RedditPostController: BaseViewController, RedditPostViewDelegate {

    var tableView: UITableView!
    private var postInfo: PostAttributes
    private var contentStack: RedditPostView!
    private let presenter = RedditPostPresenter()
    unowned var ownPostButtonClickedDelegate: RedditPostCell!
    var redditCommentsData: [Int: [String]] = [0: ["hi", "random"], 1: ["hi", "e", "qq"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setRedditPostViewDelegate(delegate: self)
        view.backgroundColor = .white

        presenter.setupCommentsView()

    }

    func setupCommentsTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.sectionHeaderHeight = 100
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.backgroundColor = .white
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: RedditCommentCell.identifier)
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            // Need the one to see the line seperator of the navbar
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 1),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

extension RedditPostController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
//            let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
//            contentStack = RedditPostView(postAttributes: postInfo, frame: rect)
//
//            let buttonStates = ownPostButtonClickedDelegate.redditPostView.presenter.getButtonStates()
//            contentStack.presenter.configurePostIfButtonSelected(buttonStates: buttonStates)
//
//            contentStack.delegate = ownPostButtonClickedDelegate
//            view.addSubview(contentStack)
////        contentStack.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            contentStack.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
////            contentStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
////            contentStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
////        ])
//            return contentStack
            let view = UIView()
//        view.addSubview()
            view.backgroundColor = UIColor.yellow
            return view
        }

        let view = UIView()
//        view.addSubview()
        if section == 1 {
            view.backgroundColor = UIColor.red
            return view
        } else {

            view.backgroundColor = UIColor.black
            return view
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let sectionData = redditCommentsData[section] {
//            let dataAmount = sectionData.count
//            return dataAmount
//        }
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section, "section")
        print(indexPath.row, "row")
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditCommentCell.identifier, for: indexPath) as! RedditCommentCell
        cell.descriptionLabel.text = "hi"
        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

