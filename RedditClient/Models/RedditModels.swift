//
// Created by Tharuka Devendra on 2019-08-27.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation


struct RedditResponse: Codable {
    let kind: String
    let data: RedditPostData
}

struct RedditPostData: Codable {
    let children: [PostData]
    let after: String
    let dist: Int
}

struct PostData: Codable {
    let kind: String
    let data: PostAttributes
}

struct PostAttributes: Codable {
    let title: String
//    let selftext: String
//    let subreddit: String
//    let score: Int
//    let ups: Int
//    let downs: Int
//    let author: String
//    let numComments: Int
//    let subredditId: String
//    let createdUtc: Int
//    let thumbnail: String
}
