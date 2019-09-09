//
// Created by Tharuka Devendra on 2019-09-07.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import UIKit
import Foundation

class RedditPostCell: UITableViewCell {
    static let identifier = "RedditPostCell"

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.text = "Testing"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()


    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(white: 1, alpha: 0)
//
        let view = UIView()
        addSubview(view)
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
//
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            // remember downward is positive and right is positive. need to divide by two because otherwise we are
            // padding each cell twice (one from the cell and then another from the cell below)
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(HomeController.cellPadding)/2),
            view.topAnchor.constraint(equalTo: topAnchor, constant: (HomeController.cellPadding)/2)
        ])

        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

    }



}
