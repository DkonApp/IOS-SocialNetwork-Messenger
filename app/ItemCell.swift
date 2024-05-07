//
//  ItemCell.swift
//
//  Created by Demyanchuk Dmitry on 01.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var actionButton: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var showRepostButton: UIButton!
    
    @IBOutlet weak var pictureViewHeight: NSLayoutConstraint!
    @IBOutlet weak var repostButtonHeight: NSLayoutConstraint!
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        contentLabel.text = ""
        
        pictureViewHeight.constant = 200
        repostButtonHeight.constant = 30
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        pictureView.image = UIImage(named: "ic_profile_default_cover")
        
        super.prepareForReuse()
    }
}
