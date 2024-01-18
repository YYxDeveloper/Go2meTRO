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
    enum urls:String {
        case ntmetroHome = "https://trainsmonitor.ntmetro.com.tw/"
        case ntmetroV = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V"
        case ntmetroK = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/K"
    }    
    func updateRailV() -> Observable<V2CurrentTimeModel>{
        return Observable.create { observer in
            
            requestJSON(.post, "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V")
                .debug()
                .subscribe(onNext: {(_,dic) in
                    do {
                     
                        let content = try JSONSerialization.data(withJSONObject: dic, options: [])
                        
                        let model = try JSONDecoder().decode(V2CurrentTimeModel.self, from: content)
                        observer.onNext(model)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }, onError: { e in
                    assertionFailure(e.localizedDescription)
                })
        }
    }
}
