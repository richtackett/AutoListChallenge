//
//  ResponseParserTests.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/7/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import XCTest
@testable import Autolist_Exercise

class ResponseParserTests: XCTestCase {
    func test_parse_success() {
        //Given
        let JSON: [String: Any] = ["photos":["total":"104362",
                                             "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then 
        if let searchResponse = searchResponse {
            XCTAssertEqual(searchResponse.totalCount, 104362)
            XCTAssertEqual(searchResponse.photots.count, 1)
        } else {
            XCTFail()
        }
    }
    
    func test_parse_missingTotal_failure() {
        //Given
        let JSON: [String: Any] = ["photos":["photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then
        XCTAssertNil(searchResponse)
    }
    
    func test_parse_missingID_failure() {
        //Given
        let JSON: [String: Any] = ["photos":["total":"104362",
                                             "photo":[["farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then
        XCTAssertNil(searchResponse)
    }
    
    func test_parse_missingFarm_failure() {
        //Given
        let JSON: [String: Any] = ["photos":["total":"104362",
                                             "photo":[["id":"36253806033", "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then
        XCTAssertNil(searchResponse)
    }
    
    func test_parse_missingServer_failure() {
        //Given
        let JSON: [String: Any] = ["photos":["total":"104362",
                                             "photo":[["id":"36253806033", "farm":5, "secret":"50344746ae", "title":"Tuba Player"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then
        XCTAssertNil(searchResponse)
    }
    
    func test_parse_missingSecret_failure() {
        //Given
        let JSON: [String: Any] = ["photos":["total":"104362",
                                             "photo":[["id":"36253806033", "farm":5, "server":"4427", "title":"Tuba Player"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then
        XCTAssertNil(searchResponse)
    }
    
    func test_parse_missingTitle_failure() {
        //Given
        let JSON: [String: Any] = ["photos":["total":"104362",
                                             "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae"]]
            ]]
        
        let responseParser = ResponseParser()
        
        //When
        let searchResponse = responseParser.parse(JSON: JSON)
        
        //Then
        XCTAssertNil(searchResponse)
    }
}
