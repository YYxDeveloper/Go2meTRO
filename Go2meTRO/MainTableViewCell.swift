//
//  MainTableViewCell.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/15.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    static let identifier = "MainTableViewCell"
    static let height = 100.0
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
