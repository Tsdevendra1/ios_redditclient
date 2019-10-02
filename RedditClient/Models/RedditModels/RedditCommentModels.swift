//
// Created by Tharuka Devendra on 2019-09-28.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
import UIKit

struct RedditResponseComments: Codable {
    let kind: String
    let data: RedditCommentData
}

struct RedditCommentData: Codable {
    let modhash: String
    let children: [CommentData]

}

struct CommentData: Codable {
    let kind: String
    let data: CommentAttributes
}

struct CommentAttributes: Codable {
    let id: String?
    let body: String?
    let replies: RedditResponseComments?

    enum CodeKeys: CodingKey {
        case id
        case body
        case replies
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodeKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        body = try container.decodeIfPresent(String.self, forKey: .body)

        // todo: make it so we can get the more data for replies
        do {
            replies = try container.decodeIfPresent(RedditResponseComments.self, forKey: .replies)
        } catch {
            // This is the stop for recursion
            replies = nil
        }
    }
}


