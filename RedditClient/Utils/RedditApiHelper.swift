//
// Created by Tharuka Devendra on 2019-08-27.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

class RedditApiHelper {

    static func getPosts(subreddit: String, completionHandler: @escaping ([PostAttributes], Int, String)->Void, after: String? = nil, count: Int? = nil) {
        var stringUrl = "https://reddit.com/r/\(subreddit).json"
        if after != nil && count != nil {
            stringUrl += "?after=\(after!)&count\(count!)"
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

    static func upvotePost(){

    }

}

