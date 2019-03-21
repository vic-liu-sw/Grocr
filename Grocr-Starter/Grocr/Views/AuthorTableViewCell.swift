//
//  AuthorTableViewCell.swift
//  
//
//  Created by vic_liu on 2019/3/21.
//

import UIKit

class AuthorTableViewCell: UITableViewCell {


    @IBOutlet var articleContent: UITextView!


    @IBOutlet var articleTitle: UILabel!


    @IBOutlet var authorName: UILabel!

    
    @IBOutlet var createDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
