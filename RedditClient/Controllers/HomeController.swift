//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

struct RedditPostTextData {
    let authorText: NSMutableAttributedString
    let scoreText: String
    let commentsTotalText: String
    let titleText: String
}

protocol HomeViewDelegate: class {
    func setupTableView(padding: CGFloat)
    func setTableViewData(data: [PostAttributes])
    func createNavbarItemWithTitle(title: String)
}

class HomeModel {

    var numberOfPostsSeen = 0
    var currentAfterId: String!
    static let cellPadding: CGFloat = 15
    let cellHeight: CGFloat = 200
    var isLoading: Bool = true
    var currentSubreddit = "all"

    func getRedditPosts(completionHandler: @escaping (([PostAttributes]) -> Void)) {

        RedditApiHelper.getPosts(subreddit: currentSubreddit, currentAfterId: currentAfterId,
                numberOfPostsAlreadySeen: numberOfPostsSeen, completionHandler: { [unowned self] (newData, seen, after) in
            self.numberOfPostsSeen += seen
            self.currentAfterId = after
            // Update the UI on the main thread
            DispatchQueue.main.async() {
                completionHandler(newData)
                self.isLoading = false
            }
        })
    }

}

class HomePresenter {
    private let homeModel = HomeModel()
    unowned var homeViewDelegate: HomeViewDelegate

    init(delegate: HomeViewDelegate) {
        self.homeViewDelegate = delegate
    }


    func setupTableView() {
        homeViewDelegate.setupTableView(padding: HomeModel.cellPadding)
    }

    func getRedditPosts() {
        homeModel.getRedditPosts(completionHandler: { [unowned self] data in
            self.homeViewDelegate.setTableViewData(data: data)
        })
    }

    func handleUserDidScroll(contentOffset: CGFloat, contentSizeHeight: CGFloat, frameSizeHeight: CGFloat) {
        // contentSize is the entire thing and frame is the space on the screen, so the actual scrollable part is the stuff offscreen which is what this calculates
        let maximumOffset = contentSizeHeight - frameSizeHeight
        let userDidReachBottom = contentOffset > maximumOffset

        if (userDidReachBottom && !homeModel.isLoading) {
            homeModel.isLoading = true
            getRedditPosts()
        }
    }

    func setNavBarItem() {
        homeViewDelegate.createNavbarItemWithTitle(title: homeModel.currentSubreddit.capitalizingFirstLetter())
    }

}

class HomeController: BaseViewController, HomeViewDelegate {


    var tableView: UITableView!
    var stateController: StateController!
    var customNavigationItem: UINavigationItem!
    private var presenter: HomePresenter!
    var tableViewData: [PostAttributes] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter.setupTableView()

        view.backgroundColor = getUIColor(hex: "#A9A9A9")
        presenter.getRedditPosts()
        stateController = StateController()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter = HomePresenter(delegate: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableView(padding: CGFloat) {
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0)
        tableView.register(RedditPostCell.self, forCellReuseIdentifier: RedditPostCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        view.addSubview(tableView)

        // table row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding)
        ])
    }

    func createRedditPostText(cellIndex: Int) -> RedditPostTextData {
        let cellData = tableViewData[cellIndex]
        let hoursSincePost = getTimeSincePostInHours(cellData.createdUtc)
        return RedditPostTextData(
                authorText: createAuthorLabelWithTimeAndSubredditText(hoursSincePost: hoursSincePost,
                        subreddit: cellData.subreddit.lowercased(), author: cellData.author),
                scoreText: createPostPointsText(score: cellData.score),
                commentsTotalText: createPostCommentsText(numComments: cellData.numComments),
                titleText: cellData.title
        )
    }

    func setTableViewData(data: [PostAttributes]) {
        if self.tableViewData.count == 0 {
            self.tableViewData = data
        } else {
            self.tableViewData += data
        }
        tableView.reloadData()
    }

    func createNavbarItemWithTitle(title: String) {
        customNavigationItem = UINavigationItem()
        customNavigationItem.title = title
        let button = UIButton()
        button.setTitle("ThiS iS  test", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: button)
        customNavigationItem.leftBarButtonItems = [backBarButton]
    }

    override func createNavbarItem() -> UINavigationItem {
        presenter.setNavBarItem()
        return customNavigationItem
    }

}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }


    @objc func handleCellTap(sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview as! RedditPostCell
        let postText = createRedditPostText(cellIndex: cell.rowNumber)
        let currentRedditPostController = RedditPostController(infoForPost: tableViewData[cell.rowNumber])
        currentRedditPostController.authorLabel.attributedText = postText.authorText
        currentRedditPostController.titleLabel.text = postText.titleText
        currentRedditPostController.scoreLabel.text = postText.scoreText
        currentRedditPostController.commentsTotalLabel.text = postText.commentsTotalText
        currentRedditPostController.delegate = cell
        navigationController?.pushViewController(currentRedditPostController, animated: true)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditPostCell.identifier, for: indexPath) as! RedditPostCell
        let postText = createRedditPostText(cellIndex: indexPath.row)
        cell.titleLabel.text = postText.titleText
        cell.scoreLabel.text = postText.scoreText
        cell.commentsTotalLabel.text = postText.commentsTotalText
        cell.authorLabel.attributedText = postText.authorText
        cell.rowNumber = indexPath.row

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cell.contentOverlay.addGestureRecognizer(tapGestureRecognizer)

        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.handleUserDidScroll(contentOffset: scrollView.contentOffset.y,
                contentSizeHeight: scrollView.contentSize.height, frameSizeHeight: scrollView.frame.size.height)
    }
}

