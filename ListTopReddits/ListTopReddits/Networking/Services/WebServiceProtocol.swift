//
//  WebServiceProtocol.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

protocol WebService {
    func get(from request: URLRequest, completion: @escaping (Result<Data, Error>)  -> Void)
}
