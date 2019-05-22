//
//  PeriodHistoryCell.swift
//  know-your-flow
//
//  Created by Olivia Thai on 5/12/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit

class PeriodHistoryCell: UITableViewCell {

    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var cycleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
