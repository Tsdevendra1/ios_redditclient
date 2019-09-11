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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    let commentsTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()


    func createBasicLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }


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
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(HomeController.cellPadding) / 2),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: (HomeController.cellPadding) / 2)
        ])

        configureStack(view: backgroundView)

    }


    func createPostButtonsArray() -> [UIView] {

        var buttonArray: [UIView] = []
        for _ in 0..<4 {
            let imageView = UIImageView(image: UIImage(named: "star")!)
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            buttonArray.append(imageView)
        }
        print(buttonArray.count)
        return buttonArray

    }

    func configureBottomRow() -> UIView {

        let view = UIView()
        view.backgroundColor = .red
        let scoreAndCommentsStack = UIStackView(arrangedSubviews: [scoreLabel, commentsTotalLabel])
        scoreAndCommentsStack.axis = .vertical
        view.addSubview(scoreAndCommentsStack)
        scoreAndCommentsStack.translatesAutoresizingMaskIntoConstraints = false
        scoreAndCommentsStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scoreAndCommentsStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scoreAndCommentsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true


        let buttonStack = UIStackView(arrangedSubviews: createPostButtonsArray())
        buttonStack.spacing = 7
        buttonStack.axis = .horizontal

        buttonStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        return view

    }

    func configureStack(view: UIView) {

        let bottomRow = configureBottomRow()
        let stackedViews: [UIView] = [titleLabel, authorLabel, bottomRow]


        let stackView = UIStackView(arrangedSubviews: stackedViews)
        stackView.axis = .vertical

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 12
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
    }


}
