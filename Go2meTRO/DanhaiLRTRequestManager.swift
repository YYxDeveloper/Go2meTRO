//
//  NetworkPart.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/17.
//

import Foundation
import RxAlamofire
import RxSwift
import UIKit

enum DirectionNow {
    case up //上行
    case down //下行
}
enum GeneralError:Error {
    case optionalError,mappingError
}
enum LRT_URLs:String {
    //未來要從後端取
    case ntmetroHome,apiFailInstead = "https://trainsmonitor.ntmetro.com.tw/"
    case ntmetroV = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/V"
    case ntmetroK = "https://trainsmonitor.ntmetro.com.tw/public/api/getCurrentTimetableV2/K"
}
class DanhaiLRTRouteManager{
    enum upToHongshulinStationKey:String, CaseIterable {
        case V01,V02,V03,V04,V05,V06,V07,V08,V09
    }
    enum upToKandingStationKey:String, CaseIterable{
        case V10,V11
    }
    enum upToWharfStationKey:String, CaseIterable{
        case V28,V27,V26
    }
    //down
    enum downToKandingStationKey:String, CaseIterable{
        case V11,V10
    }
    enum downToWharfStationKey:String, CaseIterable{
        case V26,V27,V28
    }
    enum downToHongshulinStationKey:String, CaseIterable {
        case V09,V08,V07,V06,V05,V04,V03,V02,V01
    }
    enum witchLRTLine: Int, CaseIterable {
        case upToHongshulin, upToKanding, upToWahrf
        case downToToKanding, downToWahrf, downToHongshulin
    }
    enum witchLRTColor:UInt32{
        case red = 0xEB6C5D
        case blue = 0x017DA6
        case green = 0x5B8F26
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
            throw GeneralError.mappingError
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
    func getStaticStationInfos() -> [StaticStationInfos] {
        guard let filePath = Bundle.main.path(forResource: "StationStaticInfo", ofType: "json") else {
            print("Error: JSON file not found.")
            return [StaticStationInfos(id: "V01", localizationKey: "Hongshulin")]
        }
        
        do {
            let json = try String(contentsOfFile: filePath, encoding: .utf8)
            let stations = try JSONDecoder().decode([StaticStationInfos].self, from: Data(json.utf8))
            return stations
        } catch {
            assertionFailure(error.localizedDescription)
            return [StaticStationInfos(id: "V01", localizationKey: "Hongshulin")]
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
    let upToHongshulinSubject = BehaviorSubject<StationInfos>.init(value: (StationInfos.emptyEachStatinInfo))
    let upToKandingSubject = BehaviorSubject<StationInfos>.init(value: (StationInfos.emptyEachStatinInfo))
    let upToWahrfSubject = BehaviorSubject<StationInfos>.init(value: (StationInfos.emptyEachStatinInfo))
    let downToToKandingSubject = BehaviorSubject<StationInfos>.init(value: (StationInfos.emptyEachStatinInfo))
    let downToWahrfSubject = BehaviorSubject<StationInfos>.init(value: (StationInfos.emptyEachStatinInfo))
    let downToHongshulinSubject = BehaviorSubject<StationInfos>.init(value: (StationInfos.emptyEachStatinInfo))
    private let disposeBag = DisposeBag()
    
    func getStaticStationInfos() -> [StaticStationInfos] {
        return self.routeManager.getStaticStationInfos()
    }
    func sortGpsData<T: RawRepresentable & CaseIterable>(stationKey enumType: T.Type, inputGpsData: [String: GpsData]) -> StationInfos where T.RawValue == String {

        var datas = [GpsData]()
        var keys = [String]()
        for key in T.allCases {
            if let theGpsData = inputGpsData[key.rawValue] {
                datas.append(theGpsData)
                keys.append(key.rawValue)
            }else{
                errorSubject.onNext(GeneralError.optionalError)

            }
        }
        
        return StationInfos(stations: keys, gpsDatas: datas)


    }
    func run() {
        self.routeManager.startRequestAll()
        self.errorSubject = self.routeManager.errorSubject
        routeManager.timeToUpdateSubject.subscribe(onNext: {[unowned self] _ in
            self.upToHongshulinSubject.onNext(sortGpsData(stationKey: DanhaiLRTRouteManager.upToHongshulinStationKey.self, inputGpsData: routeManager.upToHongshulinData))
            self.upToKandingSubject.onNext(sortGpsData(stationKey: DanhaiLRTRouteManager.upToKandingStationKey.self, inputGpsData: routeManager.upToKandingData))
            self.upToWahrfSubject.onNext(sortGpsData(stationKey: DanhaiLRTRouteManager.upToWharfStationKey.self, inputGpsData: routeManager.upToWahrfData))
            
            //down
            self.downToToKandingSubject.onNext(sortGpsData(stationKey: DanhaiLRTRouteManager.downToKandingStationKey.self, inputGpsData: routeManager.downToToKandingData))
            self.downToWahrfSubject.onNext(sortGpsData(stationKey: DanhaiLRTRouteManager.downToWharfStationKey.self, inputGpsData: routeManager.downToWahrfData))
            self.downToHongshulinSubject.onNext(sortGpsData(stationKey: DanhaiLRTRouteManager.downToHongshulinStationKey.self, inputGpsData: routeManager.downToHongshulinData))
        }).disposed(by: self.disposeBag)
            
    }
        

    
}

