//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate {
    func handlePanGesture(recognizer: UIPanGestureRecognizer)
}

protocol HomeViewDelegate: class {
    func setupTableView(padding: CGFloat)
    func setTableViewData(data: [PostAttributes])
}

class HomeModel {

    var numberOfPostsSeen = 0
    var currentAfterId: String!
    static let cellPadding: CGFloat = 18
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
        // todo: set title here
//        homeViewDelegate.createNavbarItemWithTitle(title: homeModel.currentSubreddit.capitalizingFirstLetter())
    }

}

class HomeController: UIViewController, HomeViewDelegate {

    var tableView: UITableView!
    private var presenter: HomePresenter!
    var tableViewData: [PostAttributes] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupTableView()
        view.backgroundColor = GlobalConfig.GREY
        presenter.getRedditPosts()
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
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        view.addSubview(tableView)

        // table row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }


    func setTableViewData(data: [PostAttributes]) {
        if self.tableViewData.count == 0 {
            self.tableViewData = data
        } else {
            self.tableViewData += data
        }
        tableView.reloadData()
    }


}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }


    @objc func handleCellTap(sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview as! PostCell
        let currentRedditPostController = PostShowController(infoForPost: tableViewData[cell.rowNumber])
        currentRedditPostController.delegate = cell
        navigationController!.pushViewController(currentRedditPostController, animated: true)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as! PostCell
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cell.contentOverlay.addGestureRecognizer(tapGestureRecognizer)
        cell.redditPostView.presenter.setPostAttributes(postAttributes: tableViewData[indexPath.row])
        cell.redditPostView.presenter.setLabelAttributes()
        cell.rowNumber = indexPath.row


        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.handleUserDidScroll(contentOffset: scrollView.contentOffset.y,
                contentSizeHeight: scrollView.contentSize.height, frameSizeHeight: scrollView.frame.size.height)
    }
}

