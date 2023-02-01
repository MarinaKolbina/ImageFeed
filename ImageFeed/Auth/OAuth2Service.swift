//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 08/01/2023.
//

import Foundation

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    private let jsonDecoder = JSONDecoder()
    
    func fetchOAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
        if var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") {
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    handler(.failure(NetworkError.codeError))
                    return
                }
                
                if let data = data {
                    do {
                        let response = try self.jsonDecoder.decode(OAuthTokenResponseBody.self, from: data)
                        handler(.success(response.accessToken))
                    } catch let error {
                        handler(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}

//final class OAuth2Service {
//    private let urlSession = URLSession.shared              // 1
//
//    private var task: URLSessionTask?                       // 2
//    private var lastCode: String?                           // 3
//
//    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        assert(Thread.isMainThread)                         // 4
//        if task != nil {                                    // 5
//            if lastCode != code {                           // 6
//                task?.cancel()                              // 7
//            } else {
//                return                                      // 8
//            }
//        } else {
//            if lastCode == code {                           // 9
//                return
//            }
//        }
//        lastCode = code                                     // 10
//        let request = makeRequest(code: code)               // 11
//        let task = urlSession.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {                      // 12
//                completion(.success("")) // TODO [Sprint 10]// 13
//                self.task = nil                             // 14
//                if error != nil {                           // 15
//                    self.lastCode = nil                     // 16
//                }
//            }
//        }
//        self.task = task                                    // 17
//        task.resume()                                       // 18
//    }
//
//    private func makeRequest(code: String) -> URLRequest {  // 19
//        guard let url = URL(string: "...\(code)") else { fatalError("Failed to create URL") }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        return request
//    }
//}
