/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties
  var items: [ArticleItem] = []
    var myPostKey: [String] = []
  //var postKey = ""
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!

  let ref = Database.database().reference(withPath: "articles-system")
//     let ref = Database.database().reference()
//    var postRef = Database.database().reference(withPath: "articlePost")
//    var publishRef = Database.database().reference(withPath: "authorPublish")

  let usersRef = Database.database().reference(withPath: "online")


  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "article",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    user = User(uid: "FakeId", email: "hungry@person.food")

 guard let myuserID = Auth.auth().currentUser?.uid else { fatalError("myuidError") }
    print("myuserID = \(myuserID)")

    ref.child("user-posts").child(myuserID).observe(.value) { (snapshot) in
         print("UUUUUUUUUU")
        print(snapshot.value as Any)
        for myChild in snapshot.children {
               let myChild = snapshot.value as! NSDictionary
           print("----------child1 =\(myChild)")
            if let myMuKeyArray = saveAuthorData.array(forKey: "vic liu") {

                print("myMuKeyArray = \(myMuKeyArray)")
                for muKey in myMuKeyArray {
                 print("muKey = \(muKey)")

            print("myFinContext = \(String(describing:  myChild[muKey]))")

                }
            }

        }


    }


//    ref.observe(.value) { (snapshot) in
//         print("5555555555555")
//        print(snapshot.value as Any)
//
//        for child in snapshot.children {
//            let myUserUid: String = (self.user.uid as? String)!
//            print("my1uid-- =\(myUserUid)")
//          let info = snapshot.value as! NSDictionary
//           let myuserpost = info["user-posts"] as? NSDictionary
//             print("----myuser-post = \(myuserpost)")
//             let myUserByarticle = myuserpost![myUserUid] as? NSDictionary
//            print("myUserByarticle----- = \(myUserByarticle)")
//
//        }
//
//    }



//        for child in snapshot.children {
//
//
//            let info = snapshot.value as! NSDictionary
//             // let key = info["key"] as? String
//             let author = info["author"] as? String ?? ""
//         print("----author = \(author)")
//
//print("xxxxx = \(info.allValues)")
//
//        }
//
//            if let mysnapshot = child as? DataSnapshot{
//
//               let qq = mysnapshot.childSnapshot(forPath: "author")
//
//
//            print(" qq = \( qq)")
//
//            }
//
//        }
//
//    }

//    ref.queryOrdered(byChild: "author" ).observe(.value, with: { snapshot in
//
//        for child in snapshot.children {
//
//            if let snapshot = child as? DataSnapshot{
//               print("TTTTTTT = \(snapshot)")
//            }
//        }
//
//    })


//   ref.child("vic liu").observeSingleEvent(of: .value) { (snapshot) in
//        print("eeeeeeee = \(snapshot)")
//    }


    //    // 1
//    ref.observe(.value, with: { snapshot in
//        print(snapshot.value as Any)
//        // 2
//        var newItems: [GroceryItem] = []
//        // 3
//        for child in snapshot.children {
//            // 4
//            if let snapshot = child as? DataSnapshot,
//                let groceryItem = GroceryItem(snapshot: snapshot) {
//                newItems.append(groceryItem)
//            }
//        }
//
//        // 5
//        self.items = newItems
//        self.tableView.reloadData()
//
//    })
////////向下排序
    // 查詢節點資料
    self.ref.queryOrdered(byChild: "liked").observe(.value, with: { snapshot in
        var newItems: [ArticleItem] = []
        for child in snapshot.children {

            if let snapshot = child as? DataSnapshot,
                let ArticleItem = ArticleItem(snapshot: snapshot) {
                newItems.append(ArticleItem)
            }
        }

        self.items = newItems
        self.tableView.reloadData()
    })
/////////

    Auth.auth().addStateDidChangeListener { auth, user in
        guard let user = user else { return }
        self.user = User(authData: user)

        // 1
        let currentUserRef = self.usersRef.child(self.user.uid)
        // 2
        currentUserRef.setValue(self.user.email)
        // 3
        currentUserRef.onDisconnectRemoveValue()
    }


    usersRef.observe(.value, with: { snapshot in
        if snapshot.exists() {
            self.userCountBarButtonItem?.title = snapshot.childrenCount.description
        } else {
            self.userCountBarButtonItem?.title = "0"
        }
    })


  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

     guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? AuthorTableViewCell else { fatalError("cellerror") }

//    guard let firstNamestringValue = saveAuthorData.string(forKey: "firstName") else {fatalError(" firstNamestringError") }
//
//    guard let lastNamestringValue = saveAuthorData.string(forKey: "lastNameText") else {fatalError("lastNamestringError") }
//
//    guard let myTextViewstringValue = saveAuthorData.string(forKey: "myTextView") else {fatalError(" myTextViewstringError") }
//
//    guard let myArticleTextSringValue = saveAuthorData.string(forKey: "ArticleText") else {fatalError(" myTextViewstringError") }


    let articleItem = items[indexPath.row]
//print("-----articleItem= \(articleItem)")
    cell.articleContent.text = articleItem.articleContent
    cell.articleTitle.text = articleItem.articleTitle
    cell.authorName.text = articleItem.author
    cell.createDate.text = articleItem.createDate


     toggleCellCheckbox(cell, isCompleted: articleItem.liked)


    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    if editingStyle == .delete {
        let articleItem = items[indexPath.row]
       articleItem.ref?.removeValue()
    }



  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 1
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    // 2
    var articleItem = items[indexPath.row]

    // 3

     let toggledCompletion = !articleItem.liked

    // 4
  //  toggleCellCheckbox(cell, isCompleted: toggledCompletion)

   articleItem.liked = toggledCompletion
    tableView.reloadData()
    // 5


    articleItem.ref?.updateChildValues([
        "liked": toggledCompletion
        ])

  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = .gray
      cell.detailTextLabel?.textColor = .gray
    }
  }
  
  // MARK: Add Item
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {

//    if let vc = storyboard?.instantiateViewController(withIdentifier: "myAuthor") {
//
//         present(vc,animated: true,completion: {})
//
//    }



///////
    let alert = UIAlertController(title: "輸入姓名",
                                  message: "發表文章",
                                  preferredStyle: .alert)

    alert.addTextField {
        (textField: UITextField!) -> Void in
        textField.placeholder = "firstName"
    }
    alert.addTextField {
        (textField: UITextField!) -> Void in
        textField.placeholder = "lastName"

    }
    alert.addTextField {
        (textField: UITextField!) -> Void in
        textField.placeholder = "文章標題"

    }

    alert.addTextField {
        (textField: UITextField!) -> Void in
        textField.placeholder = "文章內容"

    }

    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

        // 1


        guard let firsttextField = alert.textFields?[0].text else { return }

        guard let lasttextField = alert.textFields?[1].text else { return }
         guard let articleTitle = alert.textFields?[2].text else { return }
          guard let articleContent = alert.textFields?[3].text else { return }
        guard let userID = Auth.auth().currentUser?.uid else { fatalError("uidError") }
           let authorName = firsttextField + " " + lasttextField
        // 獲取當前時間

        let now: Date = Date()

        // 建立時間格式

        let dateFormat: DateFormatter = DateFormatter()

        dateFormat.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        // 將當下時間轉換成設定的時間格式

        let dateString: String = dateFormat.string(from: now)

        print("now time = \(dateString)")

       //新增
        self.ref.child("users").child(userID).setValue(["username": authorName])



        //self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
       // self.ref.child(authorName).child(userID).childByAutoId().observe(.value, with: { (snapshot) in







      self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
           let value = snapshot.value as? NSDictionary
        guard let myUserName = value?["username"] as? String else {fatalError("userNameError")}
        print("myUserName------= \(myUserName)")


            let key = self.ref.child("posts").childByAutoId().key


            self.myPostKey.append(key)
        print("myPostKey = \(self.myPostKey)")

        saveAuthorData.set(self.myPostKey, forKey: myUserName)

            let post = ["uid": userID,
                        "author": authorName,
                        "title": articleTitle,
                        "articleContent": articleContent]
            let childUpdates = ["/posts/\(key)": post,
                                "/user-posts/\(userID)/\(key)/": post]
          //  print("childUpdates =\(childUpdates)")
            self.ref.updateChildValues(childUpdates)



            })



  let articleItem = ArticleItem(uid: userID, articleTitle: articleTitle, articleContent: articleContent, author: authorName, createDate: dateString, liked: false)




            let mykey = self.ref.child(authorName).child(userID).childByAutoId().key

//        // 3
       //  let articleItemRef = self.ref.child(userID).child(authorName.lowercased())
        let articleItemRef = self.ref.child(mykey.lowercased())
//         // let articleItemRef = self.ref.child(childRef.key)
//        // 4

        articleItemRef.setValue(articleItem.toAnyObject())
   //   print("articleItem----=\(articleItem)")

      self.items.append(articleItem)
      self.tableView.reloadData()
//////

    }

    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)

    alert.addTextField()

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
}
