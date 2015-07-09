//
//  FriendTableViewCell.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 09/07/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var timeWithout: UILabel!

    @IBOutlet weak var mainEnemyLabel: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
