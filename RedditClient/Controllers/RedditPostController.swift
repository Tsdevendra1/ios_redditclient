//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

class TestClass {
    var isCollapsed: Bool
    var text: [String]

    init(text: [String], isCollapsed: Bool) {
        self.text = text
        self.isCollapsed = isCollapsed
    }
}

protocol commentHeader {
    var isCollapsed: Bool { get set }
    var rowCount: Int { get set }
}

extension commentHeader {
    var isCollapsed: Bool {
        return true
    }
}

protocol HeaderViewDelegate: class {
    func toggleSection(header: RedditPostHeaderView, section: Int)
}

protocol RedditPostViewDelegate: class {
    var ownPostButtonClickedDelegate: RedditPostCell! { get set }
    var redditCommentsData: [Int: TestClass] { get set }
    func setupCommentsTableView()
}

class RedditPostModel {

}

class RedditPostPresenter {

    private let redditPostModel = RedditPostModel()
    unowned private var redditPostViewDelegate: RedditPostViewDelegate!

    var reloadSections: ((_ section: Int) -> Void)?


    func setRedditPostViewDelegate(delegate: RedditPostViewDelegate) {
        self.redditPostViewDelegate = delegate
    }

    func setupCommentsView() {
        redditPostViewDelegate.setupCommentsTableView()
    }
}

extension RedditPostPresenter: HeaderViewDelegate {
    func toggleSection(header: RedditPostHeaderView, section: Int) {
        // toggle section

        let item: TestClass = redditPostViewDelegate.redditCommentsData[section]!
        item.isCollapsed = !item.isCollapsed
        reloadSections?(header.section)
    }
}

class RedditPostController: BaseViewController, RedditPostViewDelegate {

    var tableView: UITableView!
    private var postInfo: PostAttributes
    private var contentStack: RedditPostView!
    private let presenter = RedditPostPresenter()
    unowned var ownPostButtonClickedDelegate: RedditPostCell!
    var redditCommentsData: [Int: TestClass] = [1: TestClass(text: ["hi", "ran"], isCollapsed: false), 2: TestClass(text: ["hi", "ewqeq"], isCollapsed: false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setRedditPostViewDelegate(delegate: self)
        view.backgroundColor = .white

        presenter.reloadSections = { [unowned self] (section: Int) in
            self.tableView.beginUpdates()
            self.tableView.reloadSections([section], with: .fade)
            self.tableView.endUpdates()
        }
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
        tableView.register(RedditPostHeaderView.self, forHeaderFooterViewReuseIdentifier: RedditPostHeaderView.identifier)
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

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
            contentStack = RedditPostView(postAttributes: postInfo, frame: rect)
            let buttonStates = ownPostButtonClickedDelegate.redditPostView.presenter.getButtonStates()
            contentStack.presenter.configurePostIfButtonSelected(buttonStates: buttonStates)
            contentStack.delegate = ownPostButtonClickedDelegate
            return contentStack
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RedditPostHeaderView.identifier) as! RedditPostHeaderView
        print("hi")
        let view = UIView()
        view.backgroundColor = UIColor.black
        headerView.backgroundView = view
        headerView.item = redditCommentsData[section]!
        headerView.delegate = presenter // don't forget this line!!!      return headerView
        headerView.section = section
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: headerView, action: #selector(headerView.didTapHeader)))
        return headerView
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            let itemCollapsed = redditCommentsData[section]?.isCollapsed
            if itemCollapsed != nil && itemCollapsed! {
                return 0
            }
            return 3
        }
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

