//
//  AuthorViewController.swift
//  Grocr
//
//  Created by vic_liu on 2019/3/21.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit
//let saveAuthorData = UserDefaults.standard
class AuthorViewController: UIViewController {



    @IBOutlet var firstNameLabel: UILabel!

    @IBOutlet var lastNameLabel: UILabel!

    @IBOutlet var firstNameText: UITextField!


    @IBOutlet var lastNameText: UITextField!

    @IBOutlet var myTextView: UITextView!

    @IBOutlet var pushButton: UIButton!


    @IBAction func pushButton(_ sender: UIButton) {


        if let controller = storyboard?.instantiateViewController(withIdentifier: "myNav") as? UINavigationController {
             print("--------myNav-------")

          saveAuthorData.set(firstNameText.text, forKey: "firstName")
          saveAuthorData.set(lastNameText.text, forKey: "lastNameText")
          saveAuthorData.set(myTextView.text, forKey: "myTextView")
          saveAuthorData.synchronize()
          present(controller,animated: true,completion: {})
        }







    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
