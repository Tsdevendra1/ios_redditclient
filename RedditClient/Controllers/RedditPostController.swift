//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit


protocol commentHeader {
    var isCollapsed: Bool { get set }
    var rowCount: Int { get set }
}

extension commentHeader {
    var isCollapsed: Bool {
        return false
    }
}

protocol HeaderViewDelegate: class {
    func toggleSection(header: RedditPostHeaderView, section: Int)
}

protocol RedditPostViewDelegate: class {
    var ownPostButtonClickedDelegate: RedditPostCell! { get set }
    var redditCommentsData: [Int: TopComment] { get set }
    func setupCommentsTableView()
}

class TopComment {
    var isCollapsed: Bool
    var comments: [String]

    init(text: [String], isCollapsed: Bool) {
        self.comments = text
        self.isCollapsed = isCollapsed
    }
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

        let item: TopComment = redditPostViewDelegate.redditCommentsData[section]!
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
    var redditCommentsData: [Int: TopComment] = [1: TopComment(text: ["hi", "ran"], isCollapsed: false), 2: TopComment(text: ["hi", "ewqeq"], isCollapsed: false)]

    init(infoForPost: PostAttributes) {
        self.postInfo = infoForPost
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setRedditPostViewDelegate(delegate: self)
        view.backgroundColor = .white

        presenter.reloadSections = { [unowned self] (section: Int) in
            self.tableView.beginUpdates()
            self.tableView.reloadSections([section], with: .bottom)
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
        tableView.backgroundColor = .red
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
        let view = UIView()
        view.backgroundColor = UIColor.black
        headerView.backgroundView = view
        headerView.commentTree = redditCommentsData[section]!
        headerView.delegate = presenter // don't forget this line!!!      return headerView
        headerView.section = section
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: headerView, action: #selector(headerView.didTapHeader)))
        return headerView
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        // plus 1 is for the post inforation header
        redditCommentsData.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            let itemCollapsed = redditCommentsData[section]?.isCollapsed
            if itemCollapsed != nil && itemCollapsed! {
                return 0
            }
            // Minus 1 because one of the rows is taken by the header
            return redditCommentsData[section]!.comments.count - 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        20
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditCommentCell.identifier, for: indexPath) as! RedditCommentCell
        guard let topCommentForSection = redditCommentsData[indexPath.section] else {
            return cell
        }

        // we do plus one because index 0 of the comments is used for the headerview so row 0 is actuall the first child comment of the top comment
        let commentForRow = topCommentForSection.comments[indexPath.row + 1]
        cell.descriptionLabel.text = commentForRow
        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

