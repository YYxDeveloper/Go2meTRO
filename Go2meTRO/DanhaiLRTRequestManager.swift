//
//  NetworkPart.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/17.
//

import Foundation
import RxAlamofire
import RxSwift
enum MyError: Error {
    case someError
}
class DanhaiLRTRequestManager{
    class RouteManager{
        let currentTimeSubject = PublishSubject<V2CurrentTimeModel>()
        let errorSubject = PublishSubject<Error>()

        init() {
            self.currentTimeSubject.subscribe(onNext: {model in
                
                self.handelModel(model: model)
                
            }, onError: { [unowned self] error in
                self.errorSubject.onNext(error)
            }).dispose()
        }
        func handelModel(model:V2CurrentTimeModel) {
            let toKanding = [GpsData]()
            let toWahrf = [GpsData]()
        }
    }
    static let shared = DanhaiLRTRequestManager()
    private let disposeBag = DisposeBag()
    let updateInterVal:TimeInterval = 8
    let routeManager = RouteManager()
    
    enum urls:String {
        //未來要從後端取
        case ntmetroHome,apiFailInstead = "https://trainsmonitor.ntmetro.com.tw/"
        case ntmetroV = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V"
        case ntmetroK = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/K"
    }
    
    func startRequestAll() {
       
        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            requestJSON(.post, DanhaiLRTRequestManager.urls.ntmetroV.rawValue)
            
                .subscribe(onNext: { [unowned self](_,dic) in
                    do {
                        
                        let content = try JSONSerialization.data(withJSONObject: dic, options: [])
                        
                        let model = try JSONDecoder().decode(V2CurrentTimeModel.self, from: content)
                        routeManager.currentTimeSubject.onNext(model)
                    } catch {
                    }
                }, onError: { [unowned self] error in
                    self.routeManager.errorSubject.onNext(error)
                    assertionFailure(error.localizedDescription)
                }).disposed(by: self.disposeBag)
            
        }

    }
}
