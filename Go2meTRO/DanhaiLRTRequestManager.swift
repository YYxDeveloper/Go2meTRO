//
//  NetworkPart.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/17.
//

import Foundation
import RxAlamofire
import RxSwift

class DanhaiLRTRequestManager{
    enum routeError:Error {
        case mappingError
    }
    let errorSubject = PublishSubject<Error>()

    class RouteManager{
       
        enum witchLRTLine: Int {
            case upToHongshulin, upToKanding, upToWahrf
            case downToToKanding, downToWahrf, downToHongshulin
        }
        let currentTimeSubject = PublishSubject<V2CurrentTimeModel>()
        var upToKanding = [String :GpsData]()
        var downToToKanding = [String :GpsData]()
        var upToWahrf = [String :GpsData]()
        var downToWahrf = [String :GpsData]()
        var upToHongshulin = [String :GpsData]()
        var downToHongshulin = [String :GpsData]()
        
        func handelModel(model:V2CurrentTimeModel) throws {
            if let data = model.data {
                upToHongshulin = data.gpsData[witchLRTLine.upToHongshulin.rawValue]
                upToKanding = data.gpsData[witchLRTLine.upToKanding.rawValue]
                upToWahrf = data.gpsData[witchLRTLine.upToWahrf.rawValue]
                downToToKanding = data.gpsData[witchLRTLine.downToToKanding.rawValue]
                downToWahrf = data.gpsData[witchLRTLine.downToWahrf.rawValue]
                downToHongshulin = data.gpsData[witchLRTLine.downToHongshulin.rawValue]
                

            }else{
                throw routeError.mappingError
            }

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
                    self.errorSubject.onNext(error)
                    assertionFailure(error.localizedDescription)
                }).disposed(by: self.disposeBag)
            
        }
        routeManager.currentTimeSubject.subscribe(onNext: {[unowned self] model in
            
            do {
                try  self.routeManager.handelModel(model: model)
            } catch  {
                self.errorSubject.onNext(error)
            }
           
            
        }, onError: { [unowned self] error in
            self.errorSubject.onNext(error)
        }).disposed(by: self.disposeBag)

    }
}
