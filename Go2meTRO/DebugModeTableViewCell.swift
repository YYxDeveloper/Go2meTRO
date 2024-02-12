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
    func modifyLabelsSetting(info:StationInfos, row:Int) {
        let divid = ">>>"
        self.carNum.text = V2CurrentTimeModel.thisModelKeys.carNum.rawValue + divid + (info.gpsDatas[row].carNum ?? String.giveLoadingString())
        self.drivingTime.text = V2CurrentTimeModel.thisModelKeys.driving.rawValue + divid + info.gpsDatas[row].drivingTime
        self.routeId.text = V2CurrentTimeModel.thisModelKeys.routeId.rawValue + divid + (info.gpsDatas[row].routeId?.asString() ?? String.giveLoadingString())
        self.timeRouteId.text = V2CurrentTimeModel.thisModelKeys.tRouteId.rawValue + divid + (info.gpsDatas[row].timeRouteId?.asString() ?? String.giveLoadingString())
        self.t1.text = V2CurrentTimeModel.thisModelKeys.t1.rawValue + divid + (info.gpsDatas[row].time.asString())
        self.t3.text = V2CurrentTimeModel.thisModelKeys.t3.rawValue + divid + (info.gpsDatas[row].time3.asString())
    }

}
