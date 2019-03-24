//
//  Post.swift
//  Grocr
//
//  Created by vic_liu on 2019/3/24.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase

//class articlePost: NSObject {
//    var uid: String
//    var author: String
//    var title: String
//    var createDate: String
//    var Content: String
//    var starCount: AnyObject?
//    var stars: Dictionary<String, Bool>?
//
//    init(uid: String, author: String, title: String, createDate: String) {
//        self.uid = uid
//        self.author = author
//        self.title = title
//        self.createDate = createDate
//        self.starCount = 0 as AnyObject?
//    }
//
//    init?(snapshot: DataSnapshot) {
//        guard let dict = snapshot.value as? [String:Any] else { return nil }
//        guard let uid  = dict["uid"] as? String  else { return nil }
//        guard let author = dict["author"]  as? String else { return nil }
//        guard let title = dict["title"]  as? String else { return nil }
//        guard let createDate = dict["createDate"]  as? String else { return nil }
//        guard let starCount = dict["starCount"] else { return nil }
//
//        self.uid = uid
//        self.author = author
//        self.title = title
//        self.createDate = createDate
//        self.starCount = starCount as AnyObject?
//    }
//
//    convenience override init() {
//        self.init(uid: "", author: "", title: "", createDate:  "")
//    }
//}
