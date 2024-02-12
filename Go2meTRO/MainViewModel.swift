//
//  MainViewModel.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/2.
//

import Foundation
class MainViewModel {
    static  var isDebugMode:Bool{
#if DEBUG
        return true
#else
        return false
#endif
    }
    var openDebugSetting:Bool = false
    var directionNow = DirectionNow.up
    
}
