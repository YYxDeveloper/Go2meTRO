//
//  Rx+extension.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/8.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import RxCocoa
public extension BehaviorSubject{
    func forceGetValue() -> Element{
        do {
            return try self.value()
        } catch  {
            return StationInfos.emptyEachStatinInfo as! Element
        }
    }
}
