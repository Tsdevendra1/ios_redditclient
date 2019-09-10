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

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.text = "Testing"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let postInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.text = "Testing"
        return label
    }()





    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(white: 1, alpha: 0)

        let backgroundView = UIView()
        addSubview(backgroundView)
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            // remember downward is positive and right is positive. need to divide by two because otherwise we are
            // padding each cell twice (one from the cell and then another from the cell below)
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(HomeController.cellPadding)/2),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: (HomeController.cellPadding)/2)
        ])


        configureStack(view: backgroundView)

    }

    func configureBottomRow() -> UIView {

        let view = UIView()
        view.backgroundColor = .red
        let label = UILabel()
        view.addSubview(label)
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.text = "Testing"
        label.backgroundColor = .red
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        let label1 = UILabel()
        view.addSubview(label1)
        label1.textColor = .black
        label1.font = .systemFont(ofSize: 16)
        label1.text = "Testing"
        label1.backgroundColor = .red
        label1.numberOfLines = 0
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        label1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label1.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return view

    }

    func configureStack(view: UIView){

        let bottomRow = configureBottomRow()
        let stackedViews: [UIView] = [titleLabel, postInfoLabel, bottomRow]


        let stackView = UIStackView(arrangedSubviews: stackedViews)
        stackView.axis = .vertical
        stackView.distribution = .fill

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }



}
