//
//  AuthorViewItem.swift
//  Grocr
//
//  Created by vic_liu on 2019/3/21.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase
let saveAuthorData = UserDefaults.standard
struct AuthorViewItem {

    let ref: DatabaseReference?
    let childId: String
    let authorId: String
    let authorFirstName: String
    let authorLastName: String

    let articleTitle: String
    let articlescontent: String
    let author: String
    let createDate: String

    var liked: Bool

    init(childId: String, authorId: String, authorFirstName: String, authorLastName: String, articleTitle: String, articlescontent: String,  author: String, createDate: String, liked: Bool) {
        self.ref = nil
        self.childId = childId
        self.authorId = authorId
        self.authorFirstName = authorFirstName
        self.authorLastName = authorLastName
        self.articleTitle = articleTitle
        self.articlescontent = articlescontent
        self.author = author
        self.createDate = createDate
        self.liked = liked
    }


    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let childId = value["childId"] as? String,
            let authorId = value["authorId"] as? String,
            let authorFirstName = value["authorFirstName"] as? String,
            let authorLastName = value["authorLastName"] as? String,
            let articleTitle = value["articleTitle"] as? String,
            let articlescontent = value["articlescontent"] as? String,
            let author = value["author"] as? String,
            let createDate = value["createDate"] as? String,
            let liked = value["liked"] as? Bool else {
                return nil
        }


        self.ref = snapshot.ref
        self.childId = childId
        self.authorId = authorId
        self.authorFirstName = authorFirstName
        self.authorLastName = authorLastName
        self.articleTitle = articleTitle
        self.articlescontent = articlescontent
        self.author = author
        self.createDate = createDate
        self.liked = liked
    }


    func toAnyObject() -> Any {
        return [
            "childId": childId,
            "authorId": authorId,
            "authorFirstName": authorFirstName,
            "authorLastName": authorLastName,
            "articleTitle": articleTitle,
            "articlescontent": articlescontent,
            "author": author,
            "createDate": createDate,
            "liked": liked
        ]
    }

}
