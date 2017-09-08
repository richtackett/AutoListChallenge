//
//  SearchServiceTests.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/7/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import XCTest
@testable import Autolist_Exercise

class SearchServiceTests: XCTestCase {
    func testSearch_Success() {
        //Given
        class MockNetworkHelperSuccess: NetworkHelperProtocol {
            func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
                let JSON: [String: Any] = ["photos":["total":"104362",
                                                     "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
                    ]]
                let data = try? JSONSerialization.data(withJSONObject: JSON)
                let successRespone = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                completion(data, successRespone, nil)
            }
        }
        
        let searchService = SearchService(networkHelper: MockNetworkHelperSuccess())
        let searchExpectation = expectation(description: "")
        
        //When
        searchService.search(text: "Running", page: 1) {(result) in
            switch result {
            case .success(let searchResponse):
                searchExpectation.fulfill()
                XCTAssertEqual(searchResponse.totalCount, 104362)
            case .failure:
                XCTFail()
            }
        }
        
        //Then
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
