//
//  ReservationMgmtTableViewCell.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 7..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class ReservationMgmtTableViewCell: UITableViewCell {
    /*
     name:
     sid:
     loca:
     date: YYYY MM DD
     time: HH:mm - HH:mm
     */
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sidLabel: UILabel!
    @IBOutlet weak var locaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customView.layer.borderColor = UIColor.gray.cgColor
        customView.layer.borderWidth = 0.3
        customView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
