//
//  NetworkService.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 19/01/2023.
//
import Foundation
extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    fulfillCompletionOnMainThread(.failure(NSError(domain:"", code: statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(error))
            } else {
                fulfillCompletionOnMainThread(.failure(NSError(domain:"", code: 0)))
            }
        })
        task.resume()
        return task
    }
}
