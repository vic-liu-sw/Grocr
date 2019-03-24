//
//   authorPublish.swift
//  Grocr
//
//  Created by vic_liu on 2019/3/24.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase
class authorPublish: NSObject {
    var uid: String
    var author: String
    var text: String

    init(uid: String, author: String, text: String) {
        self.uid = uid
        self.author = author
        self.text = text
    }

    convenience override init() {
        self.init(uid: "", author: "", text: "")
    }
}
