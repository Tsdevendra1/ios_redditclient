//
// Created by Tharuka Devendra on 2019-08-11.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

enum SortComments: String {
    case top
    case confidence
}

protocol ParentCommentDelegate: class {
    func toggleSection(header: ParentCommentCell, section: Int)
}

protocol PostShowViewDelegate: class {
    var delegate: PostCell! { get set }
    var redditCommentsData: [Int: CommentChain] { get set }
    func setupCommentsTableView()
    func setTableViewData(data: [Int: CommentChain])
}

class CommentChain {
    var isCollapsed: Bool
    var comments: [Comment]

    init(comments: [Comment]) {
        self.comments = comments
        self.isCollapsed = false
    }
}

class RedditPostModel {
    var currentSorting = SortComments.top
    var subreddit: String!
    var postId: String!

    func getPostComments(subreddit: String, postId: String, sortBy: SortComments, completionHandler: @escaping (([Int: CommentChain]) -> Void)) {
        RedditApiHelper.getCommentsForPost(subreddit: subreddit, postId: postId, sortBy: sortBy, completionHandler: { data in
            DispatchQueue.main.async() {
                completionHandler(data)
            }
        })
    }
}

class PostShowPresenter {

    private let model = RedditPostModel()
    unowned private var delegate: PostShowViewDelegate!

    var reloadSections: ((_ section: Int) -> Void)?


    func setRedditPostViewDelegate(delegate: PostShowViewDelegate) {
        self.delegate = delegate
    }

    func getCommentsForPost(subreddit: String, postId: String) {
        model.getPostComments(subreddit: subreddit,
                postId: postId,
                sortBy: model.currentSorting,
                completionHandler: { [unowned self] data in
                    self.delegate.setTableViewData(data: data)
                })
    }

    func setupCommentsView() {
        delegate.setupCommentsTableView()
    }
}

extension PostShowPresenter: ParentCommentDelegate {
    func toggleSection(header: ParentCommentCell, section: Int) {
        // toggle section

        let item: CommentChain = delegate.redditCommentsData[section]!
        item.isCollapsed = !item.isCollapsed
        reloadSections?(header.section)
    }
}

class PostShowController: UIViewController, PostShowViewDelegate {

    var tableView: UITableView!
    private var postInfo: PostAttributes
    private var contentStack: PostSummaryView!
    private let presenter = PostShowPresenter()
    unowned var delegate: PostCell!
    var redditCommentsData: [Int: CommentChain] = [:]

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
            self.tableView.reloadSections([section], with: .automatic)
            self.tableView.endUpdates()
        }
        presenter.setupCommentsView()
        presenter.getCommentsForPost(subreddit: postInfo.subreddit, postId: postInfo.id)

    }

    func setTableViewData(data: [Int: CommentChain]) {
        self.redditCommentsData = data
        tableView.reloadData()
    }

    func setupCommentsTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        tableView.backgroundColor = GlobalConfig.GREY
        tableView.register(ChildCommentCell.self, forCellReuseIdentifier: ChildCommentCell.identifier)
        tableView.register(ParentCommentCell.self, forHeaderFooterViewReuseIdentifier: ParentCommentCell.identifier)
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    deinit {
        print("deinit redditPostController")
    }

}

extension PostShowController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterView")
        let view = UIView()
        view.backgroundColor = .clear
        footerView?.backgroundView = view
        return footerView
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
            contentStack = PostSummaryView(postAttributes: postInfo, frame: rect)
            contentStack.layer.shadowOpacity = 0.5
            contentStack.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            contentStack.layer.shadowRadius = 1.0
            contentStack.layer.shadowColor = UIColor.black.cgColor
            let buttonStates = delegate.redditPostView.presenter.getButtonStates()
            contentStack.presenter.configurePostIfButtonSelected(buttonStates: buttonStates)
            contentStack.delegate = delegate
            return contentStack
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ParentCommentCell.identifier) as! ParentCommentCell
        let commentForSection = redditCommentsData[section - 1]!.comments[0] as Comment

        headerView.commentView.commentLabel.text = commentForSection.body
        headerView.commentView.commentIdentifierColor.backgroundColor = GlobalConfig.colorsForCommentLevels[0]!
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
        if section == 0 || redditCommentsData.count == 0 {
            return 0
        } else {
            let itemCollapsed = redditCommentsData[section]?.isCollapsed
            if itemCollapsed != nil && itemCollapsed! {
                return 0
            }
            // Minus 1 for the comment count because one of the rows is taken by the header and minus one for the section number
            // because of the indexing (the comments start at 0) and since we added an extra sectoin for the post info header
            return redditCommentsData[section - 1]!.comments.count - 1
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChildCommentCell.identifier, for: indexPath) as! ChildCommentCell
        // minus 1 because of the indexing since we added an extra section for the post info header
        guard let commentsForSection = redditCommentsData[indexPath.section - 1] else {
            return cell
        }
        // plus 1 because the first comment is used for the header of the section (i.e. parent comment)
        let commentForRow = commentsForSection.comments[indexPath.row + 1] as Comment
        cell.commentView.commentLabel.text = commentForRow.body
        cell.commentView.commentIdentifierColor.backgroundColor = GlobalConfig.colorsForCommentLevels[commentForRow.level] ?? .red


        cell.indentationLevel = commentForRow.level
        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

