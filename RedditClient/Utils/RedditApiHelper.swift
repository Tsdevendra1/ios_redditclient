//
// Created by Tharuka Devendra on 2019-08-27.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

class RedditApiHelper {

    static func getPosts(subreddit: String) {
        let url = URL(string: "https://reddit.com/r/\(subreddit).json")!
        getUrl(url: url, completionHandler: { data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseResult = try decoder.decode(RedditResponse.self, from: data)
                print(responseResult.data.children[0].data.title)
            } catch {
                print("ERRoR", error)
            }
        })
    }

}

