//
// Created by Tharuka Devendra on 2019-09-01.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

func getUrl(url: URL, completionHandler: @escaping (Data) -> Void) {
    let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        if error != nil {
            print("api error")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("api error")
            return
        }

        if data != nil {
            completionHandler(data!)
        }

    })
    task.resume()
}