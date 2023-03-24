//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 08/01/2023.
//

import Foundation

final class OAuth2Service {
    private let urlSession = URLSession.shared              // 1
    
    private var task: URLSessionTask?                       // 2
    private var lastCode: String?                           // 3
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        let session = URLSession.shared
        let request = makeRequest(code: code)
        guard let request = request else { return }
        
        task?.cancel()
        lastCode = code
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let tokenBody):
                completion(.success(tokenBody.accessToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
                UIBlockingProgressHUD.dismiss()
                break
            }
            self.task = nil
        }
    }
    
    private func makeRequest(code: String) -> URLRequest? {
        if var urlComponents = URLComponents(string: AuthConfiguration.standard.tokenURL) {
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
                URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "client_secret", value: AuthConfiguration.standard.secretKey),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            return request
        }
        return nil
    }
}
