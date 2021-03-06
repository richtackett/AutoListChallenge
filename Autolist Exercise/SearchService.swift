//
//  SearchService.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import Foundation

enum Result{
    case success(SearchResponse)
    case failure(NSError)
}

final class SearchService {
    fileprivate let apiKey = "de2e69025fb2ec3728d90c48cd9a792c"
    fileprivate let responseParser = ResponseParser()
    fileprivate let networkHelper: NetworkHelperProtocol
    fileprivate var path: String
    static fileprivate let flickerPath = "https://api.flickr.com/services/rest/"
    
    init(networkHelper: NetworkHelperProtocol, path: String) {
        self.networkHelper = networkHelper
        self.path = path
    }
    
    convenience init() {
        self.init(networkHelper: NetworkHelper(), path: SearchService.flickerPath)
    }
    
    func search(text: String, page: Int, completion: @escaping ((Result) -> Void)) {
        guard let urlRequest = _makeRequest(text: text, page: page) else {
            let error = NSError(domain: "Autolist", code: 100, userInfo: [NSLocalizedDescriptionKey: "Could not make URLRequest"])
            completion(.failure(error))
            return
        }
        
        networkHelper.sendRequest(urlRequest: urlRequest) {[weak self] (data, response, error) in
            self?._handleRespone(data: data, response: response, error: error, completion: completion)
        }
    }
}

// MARK: Private Helper Methods
fileprivate extension SearchService {
    func _makeRequest(text: String, page: Int) -> URLRequest? {
        guard let queryString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let searchPath = "\(path)?method=flickr.photos.search&api_key=\(apiKey)&text=\(queryString)&page=\(page)&per_page=20&format=json&nojsoncallback=1"
        guard let url = URL(string: searchPath) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    func _handleRespone(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ((Result) -> Void)) {
        if let error = error {
            completion(.failure(error as NSError))
        } else {
            guard let response = response as? HTTPURLResponse else {
                let error = NSError(domain: "Autolist", code: 101, userInfo: [NSLocalizedDescriptionKey: "Response is not proper format"])
                completion(.failure(error))
                return
            }
            
            var jsonDictionary =  [String: Any]()
            if let data = data {
                let JSON = try? JSONSerialization.jsonObject(with: data)
                
                if let dict = JSON as? [String: Any] {
                    jsonDictionary = dict
                }
            }
            
            if let searchRespone = responseParser.parse(JSON: jsonDictionary),
                response.statusCode < 400 {
                completion(.success(searchRespone))
            } else {
                let error = NSError(domain: "Autolist", code: 102, userInfo: [NSLocalizedDescriptionKey: "Response is not proper format"])
                completion(.failure(error))
            }
        }
    }
}
