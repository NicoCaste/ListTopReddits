//
//  UrlSessionWebService.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation

enum NetWorkingError: Error {
    case badURL
    case serverError
    case unknowError
}

struct UrlSessionWebService: WebService {
    func get(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, result, error in
            guard let data = data,
                  let result = result as? HTTPURLResponse,
                  error == nil
            else {
                completion(.failure(error!))
                return
            }
            
            data.printAsJSON()
            switch result.statusCode {
            case 200..<300:
                data.printAsJSON()
                completion(.success(data))
            case 500..<600:
                completion(.failure(NetWorkingError.serverError))
            default:
                completion(.failure(NetWorkingError.unknowError))
            }
        }
        
        task.resume()
    }
}

