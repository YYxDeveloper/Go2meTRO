//
//  V2Model.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/16.
//

import Foundation
struct V2CurrentTimeModel: Decodable {
    let code: Int
    let message: String?
    let data: DataContainer?
}

struct DataContainer: Decodable {
    let gpsData: [[String:GpsData]]
    let displaySettings: DisplaySettings
}

struct GpsData: Codable {
    let carNum: String?
    let drivingTime: String
    let routeId: Int?
    let time: Int
    let time3: Int
    let time4: Int
    let timeRouteId: Int?
    
    private enum CodingKeys: String, CodingKey {
        case carNum
        case drivingTime
        case routeId
        case time
        case time3
        case time4
        case timeRouteId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        carNum = try container.decode(String.self, forKey: .carNum)
        drivingTime = try container.decode(String.self, forKey: .drivingTime)
        routeId = try container.decodeIfPresent(Int.self, forKey: .routeId)
        time = try container.decode(Int.self, forKey: .time)
        time3 = try container.decode(Int.self, forKey: .time3)
        time4 = try container.decode(Int.self, forKey: .time4)
        timeRouteId = try container.decodeIfPresent(Int.self, forKey: .timeRouteId)
    }
}

struct DisplaySettings: Codable {
    let startTimeUnit: Int
    let activeTimeUnit: Int
}
extension V2CurrentTimeModel {
    enum thisModelKeys:String{
        case driving, carNum, tRouteId, routeId, t1, t3
    }
    static let defaultModelKey = "V2DefaultModel"
    static func createDefaultModel() -> V2CurrentTimeModel {
        let filePath = Bundle.main.path(forResource: "V2DefaultModel", ofType: "json")!
        let json = try! String(contentsOfFile: filePath, encoding: .utf8)
        
        let jsonData:Data = json.data(using: .utf8) ?? Data()
        let decoder = JSONDecoder()
        
        let model = try!decoder.decode(V2CurrentTimeModel.self, from: jsonData)
        return model
    }
    
}
