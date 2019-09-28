//
// Created by Tharuka Devendra on 2019-09-07.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit
import Foundation

protocol RedditPostCellDelegate: class {

}


class RedditPostCellPresenter {
    unowned private var redditPostCellDelegate: RedditPostCellDelegate!

    func setRedditPostCellDelegate(delegate: RedditPostCellDelegate) {
        self.redditPostCellDelegate = delegate
    }

}

extension RedditPostCellPresenter: HandlesPostButtonClickDelegate {

    func handleUpvoteClick() {
    }

    func handleDownvoteClick() {
    }

    func handleFavouriteClick() {
    }

    func handleMoreClick() {

    }

}

class RedditPostCell: UITableViewCell, RedditPostCellDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static let identifier = "RedditPostCell"
    var presenter = RedditPostCellPresenter()
    var contentOverlay: UIView!
    var rowNumber: Int!
    var redditPostView: RedditPostInfoView

    override init(style: CellStyle, reuseIdentifier: String?) {
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        redditPostView = RedditPostInfoView(frame: rect)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        presenter.setRedditPostCellDelegate(delegate: self)

        // make the base layer transparent
        backgroundColor = UIColor(white: 1, alpha: 0)

        // This is the white background of the cell
        contentOverlay = UIView()
        addSubview(contentOverlay)
        contentOverlay.backgroundColor = .clear
        contentOverlay.layer.cornerRadius = 7.0;
        contentOverlay.layer.shadowColor = UIColor.black.cgColor
        contentOverlay.layer.shadowOpacity = 0.5;
        contentOverlay.layer.shadowRadius = 3.0;
        contentOverlay.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)


        contentOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentOverlay.leftAnchor.constraint(equalTo: leftAnchor, constant: HomeModel.cellPadding),
            contentOverlay.rightAnchor.constraint(equalTo: rightAnchor, constant: -HomeModel.cellPadding),
        ])
        contentOverlay.addSubview(redditPostView)

        redditPostView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 0
        redditPostView.topAnchor.constraint(equalTo: contentOverlay.topAnchor, constant: padding).isActive = true
        redditPostView.bottomAnchor.constraint(equalTo: contentOverlay.bottomAnchor, constant: -padding).isActive = true
        redditPostView.rightAnchor.constraint(equalTo: contentOverlay.rightAnchor, constant: -padding).isActive = true
        redditPostView.leftAnchor.constraint(equalTo: contentOverlay.leftAnchor, constant: padding).isActive = true
        redditPostView.layer.cornerRadius = contentOverlay.layer.cornerRadius

        redditPostView.layer.masksToBounds = true

    }


}

extension RedditPostCell: HandlesPostButtonClickDelegate {

    func handleUpvoteClick() {
        redditPostView.handleUpvoteClick()
    }

    func handleDownvoteClick() {
        redditPostView.handleDownvoteClick()
    }


    func handleFavouriteClick() {
        redditPostView.handleFavouriteClick()
    }

    func handleMoreClick() {
        redditPostView.handleMoreClick()
    }


}
