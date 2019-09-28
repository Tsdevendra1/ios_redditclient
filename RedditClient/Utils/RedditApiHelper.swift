//
// Created by Tharuka Devendra on 2019-08-27.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

class RedditApiHelper {

    static func getPosts(subreddit: String,
                         currentAfterId: String? = nil, numberOfPostsAlreadySeen: Int? = nil,
                         completionHandler: @escaping ([PostAttributes], Int, String) -> Void) {

        var stringUrl = "https://reddit.com/r/\(subreddit).json"
        if currentAfterId != nil && numberOfPostsAlreadySeen != nil {
            stringUrl += "?after=\(currentAfterId!)&count\(numberOfPostsAlreadySeen!)"
        }

        let url = URL(string: stringUrl)!
        getUrl(url: url, completionHandler: { data in
            let responseData = decodeData(model: RedditResponse.self, data: data)
            var cleanedData: [PostAttributes] = []
            for post in responseData!.data.children {
                cleanedData.append(post.data)
            }
            completionHandler(cleanedData, responseData!.data.dist, responseData!.data.after)
        })
    }

    static func upvotePost() {

    }

    static func getCommentsForPost(subreddit: String, postId: String, completionHandler: @escaping (([PostAttributes]) -> Void)) {
        let stringUrl = "https://reddit.com/r/\(subreddit)/comments/\(postId).json"
        let url = URL(string: stringUrl)!

        getUrl(url: url, completionHandler: { data in
            let responseData = decodeData(model: RedditResponse.self, data: data)
            var cleanedData: [PostAttributes] = []
            for post in responseData!.data.children {
                cleanedData.append(post.data)
            }
            completionHandler(cleanedData)
        })
    }

}

