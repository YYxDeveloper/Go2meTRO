//
//  NetworkPart.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/17.
//

import Foundation
import RxAlamofire
import RxSwift
class NetworManager{
    static let shared = NetworManager()
    let updateInterVal:TimeInterval = 30
    enum urls:String {
        //未來要從後端取
        case ntmetroHome,apiFailInstead = "https://trainsmonitor.ntmetro.com.tw/"
        case ntmetroV = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V"
        case ntmetroK = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/K"
    }    
    func callNTmetroV() -> Single<V2CurrentTimeModel>{
        return Single.create { single in
            
            requestJSON(.post, "https://trainsmoniaator.ntmetro.com.tw/public/api/getCurrentTimetableV2/V")
                .debug()
                .subscribe(onNext: {(_,dic) in
                    do {
                     
                        let content = try JSONSerialization.data(withJSONObject: dic, options: [])
                        
                        let model = try JSONDecoder().decode(V2CurrentTimeModel.self, from: content)
                        single(.success(model))
                    } catch {
                        single(.failure(error))
                    }
                }, onError: { error in
                    single(.failure(error))
                    assertionFailure(error.localizedDescription)
                })
        }
    }
}
