//
//  NetworkHelper.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/7/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import Foundation

protocol NetworkHelperProtocol {
    func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

final class NetworkHelper: NetworkHelperProtocol {
    fileprivate let session = URLSession.shared
    
    func sendRequest(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            completion(data, response, error)
        }
        
        task.resume()
    }
}
