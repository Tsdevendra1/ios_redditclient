//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit


protocol HeaderViewDelegate: class {
    func toggleSection(header: CommentsHeaderView, section: Int)
}

protocol RedditPostViewDelegate: class {
    var ownPostButtonClickedDelegate: RedditPostCell! { get set }
    var redditCommentsData: [Int: CommentChain] { get set }
    func setupCommentsTableView()
}

class CommentChain {
    var isCollapsed: Bool
    var comments: [String]

    init(comments: [String]) {
        self.comments = comments
        self.isCollapsed = false
    }
}

class RedditPostModel {
    func getPostComments() {
        print("getting comments")
        RedditApiHelper.getCommentsForPost(subreddit: "swift", postId: "dayxrf", completionHandler: { data in
            print(data)
        })
    }
}

class RedditPostPresenter {

    private let redditPostModel = RedditPostModel()
    unowned private var redditPostViewDelegate: RedditPostViewDelegate!

    var reloadSections: ((_ section: Int) -> Void)?


    func setRedditPostViewDelegate(delegate: RedditPostViewDelegate) {
        redditPostModel.getPostComments()
        self.redditPostViewDelegate = delegate
    }

    func setupCommentsView() {
        redditPostViewDelegate.setupCommentsTableView()
    }
}

extension RedditPostPresenter: HeaderViewDelegate {
    func toggleSection(header: CommentsHeaderView, section: Int) {
        // toggle section

        let item: CommentChain = redditPostViewDelegate.redditCommentsData[section]!
        item.isCollapsed = !item.isCollapsed
        reloadSections?(header.section)
    }
}

class RedditPostController: BaseViewController, RedditPostViewDelegate {

    var tableView: UITableView!
    private var postInfo: PostAttributes
    private var contentStack: RedditPostInfoView!
    private let presenter = RedditPostPresenter()
    unowned var ownPostButtonClickedDelegate: RedditPostCell!
    var redditCommentsData: [Int: CommentChain] = [1: CommentChain(comments: ["hi", "ran"]), 2: CommentChain(comments: ["hi", "ewqeq"])]

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
            self.tableView.reloadSections([section], with: .fade)
            self.tableView.endUpdates()
        }
        presenter.setupCommentsView()

    }

    func setupCommentsTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.backgroundColor = GlobalConfig.GREY
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: RedditCommentCell.identifier)
        tableView.register(CommentsHeaderView.self, forHeaderFooterViewReuseIdentifier: CommentsHeaderView.identifier)
        tableView.register(CommentsFooterView.self, forHeaderFooterViewReuseIdentifier: CommentsFooterView.identifier)
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            // Need the one to see the line seperator of the navbar
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 3),
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
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsFooterView.identifier) as! CommentsFooterView
        return footerView
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
            contentStack = RedditPostInfoView(postAttributes: postInfo, frame: rect)
            contentStack.layer.shadowOpacity = 0.5
            contentStack.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            contentStack.layer.shadowRadius = 1.0
            contentStack.layer.shadowColor = UIColor.black.cgColor
            let buttonStates = ownPostButtonClickedDelegate.redditPostView.presenter.getButtonStates()
            contentStack.presenter.configurePostIfButtonSelected(buttonStates: buttonStates)
            contentStack.delegate = ownPostButtonClickedDelegate
            return contentStack
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsHeaderView.identifier) as! CommentsHeaderView
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

