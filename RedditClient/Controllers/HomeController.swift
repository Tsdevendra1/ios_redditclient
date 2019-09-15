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
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -HomeController.cellPadding),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: HomeController.cellPadding)
        ])
    }

    override func createNavbarItem() -> UINavigationItem {
        let item = UINavigationItem()
        item.title = currentSubreddit.capitalizingFirstLetter()
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


    func cleanNumber(_ number: Int) -> String {
        /*
        Function turns 12300 to 12.3 (i.e. for any number over 10000)
        */
        if number < 10000 {
            return String(number)
        }
        var number: Double = Double(number)
        number = number / 1000
        return String(format: "%.1f", number) + "k"
    }


    @objc func handleCellTap(sender: UITapGestureRecognizer){
        let cell = sender.view?.superview as! RedditPostCell
        let redditPostController = RedditPostController(subreddit: cell.subreddit)
        present(redditPostController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditPostCell.identifier, for: indexPath) as! RedditPostCell
        let infoForCell = tableViewData[indexPath.row]
        let subreddit = infoForCell.subreddit.lowercased()

        cell.subreddit = subreddit
        cell.titleLabel.text = infoForCell.title
        cell.scoreLabel.text = cleanNumber(infoForCell.score) + " points"
        cell.commentsTotalLabel.text = cleanNumber(infoForCell.numComments) + " comments"

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cell.contentOverlay.addGestureRecognizer(tapGestureRecognizer)

        let currentTime = Date().timeIntervalSince1970 // in seconds
        let timeOfPost = Double(infoForCell.createdUtc) // in seconds
        // 3600 seconds, see how many hours have passed
        let hoursSincePost = Int((currentTime - timeOfPost) / 3600)
        cell.authorLabel.text = infoForCell.author

        if hoursSincePost > 24 {
            return cell
        }

        // Bolds the subreddit and makes it blue but keeps the rest of the text consistent
        let timeSincePost = NSAttributedString(string: " · \(hoursSincePost) hours ago ·")
        let boldSubreddit = NSMutableAttributedString(string: " \(subreddit)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.blue])
        let authorLabelText = NSMutableAttributedString(string: infoForCell.author)
        authorLabelText.append(timeSincePost)
        authorLabelText.append(boldSubreddit)

        cell.authorLabel.attributedText = authorLabelText

        return cell
    }


    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        // contentSize is the entire thing and frame is the space on the screen, so the actual scrollable part is the stuff offscreen which is what this calculates
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        let userDidReachBottom = contentOffset > maximumOffset

        if (userDidReachBottom && !isLoading) {
            isLoading = true;
            getRedditPostsAndReload()
        }
    }
}

