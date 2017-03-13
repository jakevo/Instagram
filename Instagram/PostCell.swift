//
//  PostCell.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var favBtn: UIImageView!
    @IBOutlet var replyBtn: UIImageView!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var message: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
