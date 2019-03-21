//
//  ArticleItem.swift
//  Grocr
//
//  Created by vic_liu on 2019/3/21.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase

struct ArticleItem {

    let ref: DatabaseReference?
    let key: String
    let articleTitle: String
    let articleContent: String
    let author: String
    let createDate: String

    var liked: Bool
    init(articleTitle: String, articleContent: String, author: String, createDate: String, liked: Bool, key: String = "article") {
        self.ref = nil
        self.key = key
        self.articleTitle = articleTitle
        self.articleContent = articleContent
        self.author = author
        self.createDate = createDate
        self.liked = liked

    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let articleTitle = value["articleTitle"] as? String,
            let articleContent = value["articleContent"] as? String,
            let author = value["author"] as? String,
            let createDate = value["createDate"] as? String,
            let liked = value["liked"] as? Bool else {
                return nil
        }

        self.ref = snapshot.ref
        self.key = snapshot.key
        self.articleTitle = articleTitle
        self.articleContent = articleContent
        self.author = author
        self.createDate = createDate
        self.liked = liked
    }

    func toAnyObject() -> Any {
        return [
            "articleTitle": articleTitle,
            "articleContent": articleContent,
            "author": author,
            "createDate": createDate,
            "liked": liked
        ]
    }
}
