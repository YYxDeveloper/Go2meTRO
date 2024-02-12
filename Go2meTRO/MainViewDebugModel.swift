//
//  MainViewDebugModel.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/12.
//

import Foundation
import UIKit
class MainViewDebugModel: MainViewModel {
    func giveMeDebugModeTableViewCell(tableView:UITableView,indexPath:IndexPath)-> DebugModeTableViewCell{
        return tableView.dequeueReusableCell(withIdentifier: "DebugModeTableViewCell", for: indexPath) as! DebugModeTableViewCell
    }
}
