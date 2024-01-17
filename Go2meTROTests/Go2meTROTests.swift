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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    func testV2Model() {
        
        // Assuming the file is a plain text file with UTF-8 encoding
        if let filePath = Bundle.main.path(forResource: "V2Model", ofType: "json") {
            do {
                let json = try String(contentsOfFile: filePath, encoding: .utf8)
                
                let jsonData:Data = json.data(using: .utf8) ?? Data()
                let decoder = JSONDecoder()
                
                let model = try decoder.decode(V2CurrentTimeModel.self, from: jsonData)
                assert(model.data.gpsData.count > 0)
                
            } catch {
                print("Error reading file: \(error.localizedDescription)")
                assertionFailure()
            }
        } else {
            print("File not found in bundle.")
        }

    }
    func testRx() {
        let networManager = NetworManager()
        let obseverable = networManager.updateRailV()
        obseverable.debug().subscribe(onNext: { model in
            assert(model.code == 0)
            
        }).disposed(by: disposeBag)
    }

}
