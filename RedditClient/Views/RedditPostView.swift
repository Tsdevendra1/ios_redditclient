//
// Created by Tharuka Devendra on 2019-09-20.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

import UIKit

class RedditPostViewController: UIView {
    var text: String

    init(text: String) {
        self.text = text
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}