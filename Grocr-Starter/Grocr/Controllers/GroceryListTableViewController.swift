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
  var items: [GroceryItem] = []

  //var items: [AuthorViewItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!



  let ref = Database.database().reference(withPath: "grocery-items")
 // let ref = Database.database().reference(withPath: "author-items")

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
    ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
        var newItems: [GroceryItem] = []
         // var newItems: [AuthorViewItem] = []
        for child in snapshot.children {

//            if let snapshot = child as? DataSnapshot,
//                let authorItem = AuthorViewItem(snapshot: snapshot) {
//                newItems.append(authorItem)
//            }

            if let snapshot = child as? DataSnapshot,
                let groceryItem = GroceryItem(snapshot: snapshot) {
                newItems.append(groceryItem)
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
//    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? AuthorTableViewCell else { fatalError("cellerror") }
//    guard let firstNamestringValue = saveAuthorData.string(forKey: "firstName") else {fatalError(" firstNamestringError") }
//
//    guard let lastNamestringValue = saveAuthorData.string(forKey: "lastNameText") else {fatalError("lastNamestringError") }
//
//    guard let myTextViewstringValue = saveAuthorData.string(forKey: "myTextView") else {fatalError(" myTextViewstringError") }
//   

// print("firstName = \(firstNamestringValue)")
// print("lastName =\(lastNamestringValue)")
//  print("myTextView = \(myTextViewstringValue)")
    let groceryItem = items[indexPath.row]
    // let authorItem = items[indexPath.row]

         cell.firstNameLabel.text = groceryItem.firstName
         cell.lastNameCell.text = groceryItem.lastName
         cell.myTextView.text = groceryItem.articleText

//    cell.textLabel?.text = groceryItem.name
//     cell.detailTextLabel?.text = groceryItem.addedByUser
//     cell.textLabel?.text = firstNamestringValue + lastNamestringValue
//    cell.detailTextLabel?.text = myTextViewstringValue

     toggleCellCheckbox(cell, isCompleted: groceryItem.liked)


    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    if editingStyle == .delete {
        let groceryItem = items[indexPath.row]
        groceryItem.ref?.removeValue()
    }
//    if editingStyle == .delete {
//      items.remove(at: indexPath.row)
//      tableView.reloadData()
//    }


  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 1
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    // 2
    var groceryItem = items[indexPath.row]
    // let authorItem = items[indexPath.row]
    // 3
    //let toggledCompletion = !groceryItem.completed
     let toggledCompletion = !groceryItem.liked
    // let toggledCompletion = !authorItem.liked
    // 4
    toggleCellCheckbox(cell, isCompleted: toggledCompletion)

    groceryItem.liked = toggledCompletion
    tableView.reloadData()
    // 5
//    authorItem.ref?.updateChildValues([
//        "liked": toggledCompletion
//        ])

    groceryItem.ref?.updateChildValues([
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
        textField.placeholder = "文章"

    }

    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

        // 1
//        guard let textField = alert.textFields?.first,
//            let text = textField.text else { return }

        guard let firsttextField = alert.textFields?[0].text else { return }

        guard let lasttextField = alert.textFields?[1].text else { return }
         guard let articletextField = alert.textFields?[2].text else { return }
        //let textField = alert.textFields![0]

//      let groceryItem = GroceryItem(name: textField.text!,
//                                    addedByUser: self.user.email,
//                                    completed: false)

        // 2


        let groceryItem = GroceryItem(firstName: firsttextField,
                                      lastName: lasttextField,
                                      articleText: articletextField,
                                     liked: false)
      
        // 3
        let groceryItemRef = self.ref.child(firsttextField.lowercased())

        // 4
        groceryItemRef.setValue(groceryItem.toAnyObject())


      self.items.append(groceryItem)
      self.tableView.reloadData()
////////

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
