//
// Created by Tharuka Devendra on 2019-08-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

enum MenuOptions: Int, CustomStringConvertible {
    case UserName
    case Profile
    case Messaging
    case Settings
    case Subreddits
    var description: String {
        switch self {
        case .Settings:
            return "Settings"
        case .Profile:
            return "Profile"
        case .Messaging:
            return "Messaging"
        case .Subreddits:
            return "Subreddit"
        case .UserName:
            return "Username"
        }
    }

}

