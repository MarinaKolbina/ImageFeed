//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 08/01/2023.
//
//
import Foundation
//
//final class OAuth2Service {
//
//    private enum NetworkError: Error {
//        case codeError
//    }
//
//    private let jsonDecoder = JSONDecoder()
//
//    func fetchOAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
//            if var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") {
//                urlComponents.queryItems = [
//                   URLQueryItem(name: "client_id", value: AccessKey),
//                   URLQueryItem(name: "redirect_uri", value: RedirectURI),
//                   URLQueryItem(name: "code", value: code),
//                   URLQueryItem(name: "client_secret", value: SecretKey),
//                   URLQueryItem(name: "grant_type", value: "authorization_code")
//                 ]
//                var request = URLRequest(url: urlComponents.url!)
//                request.httpMethod = "POST"
//
//                let task = URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
//                    guard let self = self else { return }
//
//                    if let error = error {
//                      handler(.failure(error))
//                      return
//                    }
//
//                    if let response = response as? HTTPURLResponse,
//                       response.statusCode < 200 || response.statusCode >= 300 {
//                      handler(.failure(NetworkError.codeError))
//                      return
//                    }
//
//                    if let data = data {
//                        do {
//                            let response = try self.jsonDecoder.decode(
//                                OAuthTokenResponseBody.self, from: data)
//                            DispatchQueue.main.async {
//                                handler(.success(response.accessToken))
//                            }
//                        } catch let error {
//                            handler(.failure(error))
//                        }
//                    }
//                }
//                task.resume()
//            }
//        }
//}
//

final class OAuth2Service {
    private let urlSession = URLSession.shared              // 1
    
    private var task: URLSessionTask?                       // 2
    private var lastCode: String?                           // 3
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)                         // 4
        if lastCode == code { return }                              // 1
        task?.cancel()                                      // 2
        lastCode = code                                     // 3
        let request = makeRequest(code: code)               // 11
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {                      // 12
                self.task = nil                             // 14
                if error != nil {                           // 15
                    self.lastCode = nil                     // 16
                } else {
                    guard let data = data else { self.lastCode = nil }
                    do {
                        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        completion(.success(tokenResponse.accessToken))
                    } catch {
                        self.lastCode = nil
                    }
                }
            }
        }
        self.task = task                                    // 17
        task.resume()                                       // 18
    }
    
//    private var mostPopularMoviesUrl: URL {
//        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_6f8pl21k") else {
//            preconditionFailure("Unable to construct mostPopularMoviesUrl") // Если мы не смогли преобразовать строку в URL, то наше приложение упадёт с ошибкой
//        }
//        return url
//    }
//
//    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
//        networkClient.fetch(url: mostPopularMoviesUrl) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
//                    handler(.success(mostPopularMovies))
//                } catch {
//                    handler(.failure(error))
//                }
//            case .failure(let error):
//                handler(.failure(error))
//            }
//        }
//    }
    
    private func makeRequest(code: String) -> URLRequest {  // 19
        if var urlComponents = URLComponents(string: TokenURL) {
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: AccessKey),
                URLQueryItem(name: "redirect_uri", value: RedirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "client_secret", value: SecretKey),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            return request
        }
    }
}
