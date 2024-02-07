//
//  Go2meTROTests.swift
//  Go2meTROTests
//
//  Created by 呂子揚 on 2024/1/16.
//

import XCTest
import RxAlamofire
import RxSwift
@testable import Go2meTRO

final class Go2meTROTests: XCTestCase {
    let disposeBag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    override class func setUp() {
        super.setUp()
        DanhaiLRTRequestManager.shared.run()

    }
    func testV2Model() {
        
        // Assuming the file is a plain text file with UTF-8 encoding
        if let filePath = Bundle.main.path(forResource: "V2Model", ofType: "json") {
            do {
                let json = try String(contentsOfFile: filePath, encoding: .utf8)
                
                let jsonData:Data = json.data(using: .utf8) ?? Data()
                let decoder = JSONDecoder()
                
                let model = try decoder.decode(V2CurrentTimeModel.self, from: jsonData)
//                assert(model.data!.gpsData.count > 0)
            } catch {
                print("Error reading file: \(error.localizedDescription)")
                assertionFailure()
            }
        } else {
            print("File not found in bundle.")
        }

    }
    func testV2CurrentTimeModel() {
        let model = V2CurrentTimeModel.createDefaultModel()
        assert(model.message == V2CurrentTimeModel.defaultModelKey)
    }
    func testDownToWahrfSubject()  {
        let expectation = XCTestExpectation(description: "Closure should be called")

        DanhaiLRTRequestManager.shared.downToToKandingSubject.subscribe(onNext: {eachStationInfo in
            assert(eachStationInfo.GpsDatas.count == 2)
            expectation.fulfill()

        }).disposed(by: self.disposeBag)
        wait(for: [expectation], timeout: 5.0)
    }
    func testStringExtensiob() {
        let intValue = 42
        let stringValue = intValue.asString()
        let floatValue = 3.14
        let doubleValue = 2.718
        
        assert("42" == stringValue )
        assert(floatValue.asString() == "3.14")
        assert(doubleValue.asString() == "2.718")
    }

}
