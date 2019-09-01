//
// Created by Tharuka Devendra on 2019-09-01.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation

func decodeData<T>(model: T.Type, data: Data) -> T?
        where T: Decodable {
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let responseResult = try decoder.decode(model.self, from: data)
        return responseResult
    } catch {
        print("ERRoR", error)
    }
    return nil
}


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