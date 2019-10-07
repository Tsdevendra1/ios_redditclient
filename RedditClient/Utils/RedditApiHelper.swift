//
// Created by Tharuka Devendra on 2019-08-27.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

struct Comment {
    var body: String
    var level: Int
}

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

    static func getCommentsForPost(subreddit: String, postId: String, sortBy: SortComments, completionHandler: @escaping (([Int: CommentChain]) -> Void)) {
        let stringUrl = "https://reddit.com/r/\(subreddit)/comments/\(postId).json?sort=\(sortBy.rawValue)"
        let url = URL(string: stringUrl)!

        getUrl(url: url, completionHandler: { data in
            let responseData = decodeData(model: Array<RedditResponseComments>.self, data: data)
            let postCommentsData = responseData?[1].data.children
            guard let commentsData = postCommentsData else {
                return
            }

            var commentsTracker: [Int: CommentChain] = [:]
            for (index, comment) in commentsData.enumerated() {

                var currentCommentChain: [Comment] = []
                let data: CommentAttributes = comment.data
                if let commentBody = data.body {
                    currentCommentChain.append(Comment(body: commentBody, level: 0))
                }
                if let replies = data.replies {
                    dfsvisit(currentReplies: replies, currentCommentChain: &currentCommentChain, level: 0, parentId: data.id)
                }
                commentsTracker[index] = CommentChain(comments: currentCommentChain)
            }


            completionHandler(commentsTracker)
        })
    }

}

