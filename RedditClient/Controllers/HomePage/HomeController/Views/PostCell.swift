//
// Created by Tharuka Devendra on 2019-09-07.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit
import Foundation

protocol PostCellDelegate: class {

}


class PostCellPresenter {
    unowned private var redditPostCellDelegate: PostCellDelegate!

    func setRedditPostCellDelegate(delegate: PostCellDelegate) {
        self.redditPostCellDelegate = delegate
    }

}

extension PostCellPresenter: HandlesPostButtonClickDelegate {

    func handleUpvoteClick() {
    }

    func handleDownvoteClick() {
    }

    func handleFavouriteClick() {
    }

    func handleMoreClick() {

    }

}

class PostCell: UITableViewCell, PostCellDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static let identifier = "RedditPostCell"
    var presenter = PostCellPresenter()
    var contentOverlay: UIView!
    var rowNumber: Int!
    var redditPostView: PostSummaryView

    override init(style: CellStyle, reuseIdentifier: String?) {
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        redditPostView = PostSummaryView(frame: rect)
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
            // remember downward is positive and right is positive. need to divide by two because otherwise we are
            // padding each cell twice (one from the cell and then another from the cell below and above)
            contentOverlay.topAnchor.constraint(equalTo: topAnchor, constant: (HomeModel.cellPadding)),
            contentOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
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

extension PostCell: HandlesPostButtonClickDelegate {

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
