//
//  NetworkPart.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/17.
//

import Foundation
import RxAlamofire
import RxSwift
enum LRT_URLs:String {
    //未來要從後端取
    case ntmetroHome,apiFailInstead = "https://trainsmonitor.ntmetro.com.tw/"
    case ntmetroV = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V"
    case ntmetroK = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/K"
}
class DanhaiLRTRouteManager{
    enum routeError:Error {
        case mappingError
    }
    enum witchLRTLine: Int {
        case upToHongshulin, upToKanding, upToWahrf
        case downToToKanding, downToWahrf, downToHongshulin
    }
    let errorSubject = PublishSubject<Error>()
    let currentTimeSubject = PublishSubject<V2CurrentTimeModel>()
    let timeToUpdateSubject = PublishSubject<Void>()
    //datas
    var upToKandingData = [String :GpsData]()
    var downToToKandingData = [String :GpsData]()
    var upToWahrfData = [String :GpsData]()
    var downToWahrfData = [String :GpsData]()
    var upToHongshulinData = [String :GpsData]()
    var downToHongshulinData = [String :GpsData]()
    
    private let disposeBag = DisposeBag()

    func handelModel(model:V2CurrentTimeModel) throws {
        if let data = model.data {
            upToHongshulinData = data.gpsData[witchLRTLine.upToHongshulin.rawValue]
            upToKandingData = data.gpsData[witchLRTLine.upToKanding.rawValue]
            upToWahrfData = data.gpsData[witchLRTLine.upToWahrf.rawValue]
            downToToKandingData = data.gpsData[witchLRTLine.downToToKanding.rawValue]
            downToWahrfData = data.gpsData[witchLRTLine.downToWahrf.rawValue]
            downToHongshulinData = data.gpsData[witchLRTLine.downToHongshulin.rawValue]
            timeToUpdateSubject.onNext(())
            
        }else{
            throw routeError.mappingError
        }
        
    }
    func startRequestAll() {
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            requestJSON(.post, LRT_URLs.ntmetroV.rawValue)
            
                .subscribe(onNext: { [unowned self](_,dic) in
                    do {
                        
                        let content = try JSONSerialization.data(withJSONObject: dic, options: [])
                        
                        let model = try JSONDecoder().decode(V2CurrentTimeModel.self, from: content)
                        self.currentTimeSubject.onNext(model)
                    } catch {
                    }
                }, onError: { [unowned self] error in
                    self.errorSubject.onNext(error)
                    assertionFailure(error.localizedDescription)
                }).disposed(by: self.disposeBag)
            
        }
        
        
    }
}

class DanhaiLRTRequestManager{
    

    static let shared = DanhaiLRTRequestManager()
    let updateInterVal:TimeInterval = 8
    
    lazy var routeManager:DanhaiLRTRouteManager = {
        let routeManager = DanhaiLRTRouteManager()
        routeManager.currentTimeSubject.subscribe(onNext: {[unowned self] model in
            
            do {
                try  self.routeManager.handelModel(model: model)
                
            } catch  {
                self.errorSubject.onNext(error)
            }
            
            
        }, onError: { [unowned self] error in
            self.errorSubject.onNext(error)
        }).disposed(by: self.disposeBag)
        
        return routeManager
    }()
    
    var errorSubject = PublishSubject<Error>()
    let upToHongshulinSubject = PublishSubject<[String :GpsData]>()
    let upToKandingSubject = PublishSubject<[String :GpsData]>()
    let upToWahrfSubject = PublishSubject<[String :GpsData]>()
    let downToToKandingSubject = PublishSubject<[String :GpsData]>()
    let downToWahrfSubject = PublishSubject<[String :GpsData]>()
    let downToHongshulinSubject = PublishSubject<[String :GpsData]>()
    private let disposeBag = DisposeBag()

    private var pickleupToKandingData:[String :GpsData]{
        var pickle = routeManager.upToHongshulinData
        pickle
        return pickle
    }
    func run() {
        self.routeManager.startRequestAll()
        self.errorSubject = self.routeManager.errorSubject
        routeManager.timeToUpdateSubject.subscribe(onNext: {[unowned self] _ in
            self.upToHongshulinSubject.onNext(routeManager.upToHongshulinData)
            self.upToKandingSubject.onNext(routeManager.upToKandingData)
            self.upToWahrfSubject.onNext(routeManager.upToWahrfData)
            self.downToToKandingSubject.onNext(routeManager.downToToKandingData)
            self.downToWahrfSubject.onNext(routeManager.downToWahrfData)
            self.downToHongshulinSubject.onNext(routeManager.downToHongshulinData)
            
            
            
        }).disposed(by: self.disposeBag)
            
    }
        

    
}
