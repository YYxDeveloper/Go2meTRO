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
    private let disposeBag = DisposeBag()
    let updateInterVal:TimeInterval = 8
    let v2CurrentTimeSubject = PublishSubject<V2CurrentTimeModel>()
    enum urls:String {
        //未來要從後端取
        case ntmetroHome,apiFailInstead = "https://trainsmonitor.ntmetro.com.tw/"
        case ntmetroV = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V"
        case ntmetroK = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/K"
    }
    
    func callNTmetroV() {
       
            
                requestJSON(.post, NetworManager.urls.ntmetroV.rawValue)
               
                .subscribe(onNext: { [unowned self](_,dic) in
                    do {
                     
                        let content = try JSONSerialization.data(withJSONObject: dic, options: [])
                        
                        let model = try JSONDecoder().decode(V2CurrentTimeModel.self, from: content)
                        self.v2CurrentTimeSubject.onNext(model)
                    } catch {
                    }
                }, onError: { error in
                    self.v2CurrentTimeSubject.onError(error)
                    assertionFailure(error.localizedDescription)
                }).disposed(by: disposeBag)

    }

    func startUpdateTimeTable() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.callNTmetroV()
        }
           
           
            
    }
}
