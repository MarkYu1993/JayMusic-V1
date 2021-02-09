//
//  SongCell.swift
//  JayMusic
//
//  Created by Mark Yu on 2021/2/5.
//  Copyright © 2021 Mark Yu. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
