//
//  InviteFriendTableViewCell.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 08/07/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class InviteFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
