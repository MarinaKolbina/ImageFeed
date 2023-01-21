//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 18/01/2023.
//

import Foundation

final class ProfileImageService {
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        let session = URLSession.shared
        let token = oAuth2TokenStorage.token
        guard let token = token else { return }
        
        let request = makeRequest(username: username, token: token)
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileImage, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileImage):
                self.avatarURL = profileImage.small
                completion(.success(profileImage.small))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImage.small])
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
        task.resume()
    }
    
    private func makeRequest(username: String, token: String) -> URLRequest {
        guard let url = URL(string: "\(BaseURL)/users/\(username)") else { fatalError("Failed to create URL") }
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
        
    }
}
