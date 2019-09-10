//
// Created by Tharuka Devendra on 2019-09-09.
// Copyright (c) 2019 Tharuka Devendra. All rights reserved.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}