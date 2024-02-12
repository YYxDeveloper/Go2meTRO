//
//  OriginalCurrentTableViewCell.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/3.
//

import UIKit

class DebugModeTableViewCell: UITableViewCell {
    static let heigh:CGFloat = 100
    @IBOutlet weak var drivingTime: UILabel!
    @IBOutlet weak var carNum: UILabel!
    @IBOutlet weak var timeRouteId: UILabel!
    @IBOutlet weak var routeId: UILabel!
    @IBOutlet weak var t1: UILabel!
    @IBOutlet weak var t3: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
