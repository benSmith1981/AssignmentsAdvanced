//
//  PlotCell.swift
//  OMDB
//
//  Created by Ivo  Nederlof on 01-02-17.
//  Copyright © 2017 Dutch Melon. All rights reserved.
//

import UIKit

class PlotCell: UITableViewCell {

    @IBOutlet var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
