//
//  String+extension.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/7.
//

import Foundation
extension Numeric{
    func asString() -> String {
        return String(describing: self)
    }
  
}
extension String{
    static func giveLoadingString() -> String {
        return NSLocalizedString("loading", comment: "loading")
    }
}
