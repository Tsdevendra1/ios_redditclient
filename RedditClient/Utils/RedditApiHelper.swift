//
// Created by Tharuka Devendra on 2019-08-27.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

class RedditApiHelper {

    static func getPosts(subreddit: String) {
        let url = URL(string: "https://reddit.com/r/\(subreddit).json")!
        print(url)

        let task = URLSession.shared.dataTask(with: url) { (result) in
            switch result {
            case .success(let response, let data):
                // Handle Data and Response
                do {
                    let responseResult = try JSONDecoder().decode(RedditGenericResponse.self, from: data)
                    print(responseResult.kind)
                } catch {
                    print("ERRoR", error)
                }
                break
            case .failure(let error):
                // Handle Error
                break
            }
        }
        task.resume()
    }

}

