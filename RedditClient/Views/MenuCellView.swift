//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//
import UIKit

class MenuCellView: UITableViewCell {
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


