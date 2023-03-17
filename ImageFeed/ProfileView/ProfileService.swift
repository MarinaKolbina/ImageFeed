//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 17/01/2023.
//

import Foundation


private enum NetworkError: Error {
    case codeError
}

final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    static let shared = ProfileService()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let session = URLSession.shared
        let request = makeRequest(token: token)
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username,
                                      first_name: profileResult.first_name,
                                      last_name: profileResult.last_name,
                                      bio: profileResult.bio)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
        task.resume()
    }
    
    func updateProfileDetails(profile: Profile) {
        self.profile = profile
    }
    
    
    
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(AuthConfiguration.standard.baseURL)/me") else { fatalError("Failed to create URL") }
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
