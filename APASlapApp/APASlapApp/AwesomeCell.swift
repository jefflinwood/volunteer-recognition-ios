//
//  AwesomeCell.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

class AwesomeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var authorImageView: UIImageView!

    @IBOutlet weak var volunteerDisplayNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.layer.cornerRadius = 22
        authorImageView.layer.borderColor = UIColor.lightGray.cgColor
        authorImageView.layer.borderWidth = 1
        authorImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
