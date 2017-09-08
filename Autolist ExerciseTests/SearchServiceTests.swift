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
    func test_search_success() {
        //Given
        class MockNetworkHelper: NetworkHelperProtocol {
            func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
                let JSON: [String: Any] = ["photos":["total":"104362",
                                                     "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
                    ]]
                let data = try? JSONSerialization.data(withJSONObject: JSON)
                let successRespone = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                completion(data, successRespone, nil)
            }
        }
        
        let searchService = SearchService(networkHelper: MockNetworkHelper(), path: "https://api.flickr.com/services/rest/")
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
    
    func test_search_makeRequest_failure() {
        //Given
        class MockNetworkHelper: NetworkHelperProtocol {
            func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
                let JSON: [String: Any] = ["photos":["total":"104362",
                                                     "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
                    ]]
                let data = try? JSONSerialization.data(withJSONObject: JSON)
                let failureRespone = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
                completion(data, failureRespone, nil)
            }
        }
        
        let searchService = SearchService(networkHelper: MockNetworkHelper(), path: "😃")
        let searchExpectation = expectation(description: "")
        
        //When
        searchService.search(text:"Running", page: 1) {(result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                searchExpectation.fulfill()
                XCTAssertEqual(error.code, 100)
            }
        }
        
        //Then
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_search_response_failure() {
        //Given
        class MockNetworkHelper: NetworkHelperProtocol {
            func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
                let JSON: [String: Any] = ["photos":["total":"104362",
                                                     "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
                    ]]
                let data = try? JSONSerialization.data(withJSONObject: JSON)
                let failureRespone = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
                completion(data, failureRespone, nil)
            }
        }
        
        let searchService = SearchService(networkHelper: MockNetworkHelper(), path: "https://api.flickr.com/services/rest/")
        let searchExpectation = expectation(description: "")
        
        //When
        searchService.search(text:"Running", page: 1) {(result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                searchExpectation.fulfill()
                XCTAssertEqual(error.code, 102)
            }
        }
        
        //Then
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_search_jsonFormat_failure() {
        //Given
        class MockNetworkHelper: NetworkHelperProtocol {
            func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
                let BadJSON: [String: Any] = ["photos":["total":"104362",
                                                     "pictures":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
                    ]]
                let data = try? JSONSerialization.data(withJSONObject: BadJSON)
                let successRespone = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                completion(data, successRespone, nil)
            }
        }
        
        let searchService = SearchService(networkHelper: MockNetworkHelper(), path: "https://api.flickr.com/services/rest/")
        let searchExpectation = expectation(description: "")
        
        //When
        searchService.search(text:"Running", page: 1) {(result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                searchExpectation.fulfill()
                XCTAssertEqual(error.code, 102)
            }
        }
        
        //Then
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_search_urlResponse_failure() {
        //Given
        class MockNetworkHelper: NetworkHelperProtocol {
            func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
                let JSON: [String: Any] = ["photos":["total":"104362",
                                                     "photo":[["id":"36253806033", "farm":5, "server":"4427", "secret":"50344746ae", "title":"Tuba Player"]]
                    ]]
                let data = try? JSONSerialization.data(withJSONObject: JSON)
                let invalidResponse = URLResponse(url: URL(string: "http://example.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
                completion(data, invalidResponse, nil)
            }
        }
        
        let searchService = SearchService(networkHelper: MockNetworkHelper(), path: "https://api.flickr.com/services/rest/")
        let searchExpectation = expectation(description: "")
        
        //When
        searchService.search(text:"Running", page: 1) {(result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                searchExpectation.fulfill()
                XCTAssertEqual(error.code, 101)
            }
        }
        
        //Then
        waitForExpectations(timeout: 10, handler: nil)
    }
}
