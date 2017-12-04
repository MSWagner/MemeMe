//
//  MemeTableCell.swift
//  MemeMe
//
//  Created by Matthias Wagner on 04.12.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
