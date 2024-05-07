//
//  ItemsCommentCell.swift
//
//  Created by Demyanchuk Dmitry on 02.02.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit

class ItemsCommentCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameView: UILabel!
    @IBOutlet weak var commentView: UILabel!
    @IBOutlet weak var timeAgoView: UILabel!
    

    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}
