//
// Created by Tharuka Devendra on 2019-08-05.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit

class HomeController: BaseViewController {

    var tableView: UITableView!
    var tableViewData: [PostAttributes] = []
    var seen = 0
    var currentAfter: String!
    // when it loads it will be loading data
    var isLoading: Bool = true
    var currentSubreddit = "all"
    static let cellPadding: CGFloat = 15
    let cellHeight: CGFloat = 200


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()

        view.backgroundColor = getUIColor(hex: "#A9A9A9")
        getRedditPostsAndReload()
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0)
        tableView.register(RedditPostCell.self, forCellReuseIdentifier: RedditPostCell.identifier)
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        // table row height
        tableView.rowHeight = 150
//        tableView.estimatedRowHeight = 600

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -HomeController.cellPadding),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: HomeController.cellPadding)
        ])
    }

    override func createBasicNavItem() -> UINavigationItem {
        let item = UINavigationItem()
        item.title = "HI"
        let button = UIButton()
        button.setTitle("ThiS iS  test", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: button)
        item.leftBarButtonItems = [backBarButton]
        return item
    }

    func getRedditPostsAndReload() {

        RedditApiHelper.getPosts(subreddit: currentSubreddit, completionHandler: { (newData, seen, after) in
            self.tableViewData += newData
            self.seen += seen
            self.currentAfter = after
            // Update the UI on the main thread
            DispatchQueue.main.async() {
                self.tableView.reloadData()
                self.isLoading = false;
            }
        }, after: currentAfter, count: self.seen)
    }

}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditPostCell.identifier, for: indexPath) as! RedditPostCell
        cell.descriptionLabel.text = tableViewData[indexPath.row].title
        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        // contentsize is the entire thing and frame is the space on the screen, so the actual scrollable part is the stuff offscreen which is what this calculates
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        let userDidReachBottom = contentOffset > maximumOffset

        if (userDidReachBottom && !isLoading) {
            isLoading = true;
            getRedditPostsAndReload()
        }
    }
}

