import Foundation
import UIKit

func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
    var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cleanString.hasPrefix("#")) {
        cleanString.remove(at: cleanString.startIndex)
    }

    if ((cleanString.count) != 6) {
        return nil
    }

    var rgbValue: UInt32 = 0
    Scanner(string: cleanString).scanHexInt32(&rgbValue)

    return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
    )
}

func cleanNumber(_ number: Int) -> String {
    /*
    Function turns 12300 to 12.3 (i.e. for any number over 10000)
    */
    if number < 10000 {
        return String(number)
    }
    var number: Double = Double(number)
    number = number / 1000
    return String(format: "%.1f", number) + "k"
}

func getTimeSincePostInHours(_ unixTimeSincePost: Int) -> Int {
    let currentTime = Date().timeIntervalSince1970 // in seconds
    let timeOfPost = Double(unixTimeSincePost) // in seconds
    return Int((currentTime - timeOfPost) / 3600) // 3600 seconds in an hour
}

func createPostPointsText(score: Int) -> String {
    return cleanNumber(score) + " points"
}

func createPostCommentsText(numComments: Int) -> String {
    return cleanNumber(numComments) + " comments"
}


func createAuthorLabelWithTimeAndSubredditText(hoursSincePost: Int, subreddit: String, author: String) -> NSMutableAttributedString {
    // Bolds the subreddit and makes it blue but keeps the rest of the text consistent
    let timeSincePost = NSAttributedString(string: " · \(hoursSincePost) hours ago ·")
    let boldSubreddit = NSMutableAttributedString(string: " \(subreddit)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.blue])
    let authorLabelText = NSMutableAttributedString(string: author)
    authorLabelText.append(timeSincePost)
    authorLabelText.append(boldSubreddit)
    return authorLabelText

}

