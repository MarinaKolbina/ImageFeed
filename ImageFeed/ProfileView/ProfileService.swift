//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 17/01/2023.
//

import Foundation

struct Links: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}

struct ProfileResult: Codable {
    var id: String
    var updated_at: String
    var username: String
    var first_name: String
    var last_name: String
    var twitter_username: String
    var portfolio_url: String?
    var bio: String
    var total_likes: Int
    var total_photos: Int
    var total_collections: Int
    var followed_by_user: Bool
    var downloads: Int
    var uploads_remaining: Int
    var instagram_username: String
    var location: String?
    var email: String
    var links: Links
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String
    
    init(username: String, first_name: String, last_name: String, bio: String) {
        self.username = username
        self.name = "\(first_name) \(last_name)"
        self.loginName = "@\(username)"
        self.bio = bio
    }
}

private enum NetworkError: Error {
    case codeError
}

final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        var request = makeRequest(token: token)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {                      // 12
                self.task = nil                             // 14
                if error != nil {                           // 15
                    self.lastToken = nil                     // 16
                } else {
                    guard let data = data else { self.lastToken = nil }
                    do {
                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                        let profile = Profile(username: profileResult.username, first_name: profileResult.first_name, last_name: profileResult.last_name, bio: profileResult.bio)
                        completion(.success(profile))
                    } catch {
                        self.lastToken = nil
                    }
                }
            }
            self.task = task
            task.resume()
            
        }
    }
        
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(DefaultBaseURL)/me") else { fatalError("Failed to create URL") }
            
        var request = URLRequest(url: url)
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
        
//        let request = makeRequest(code: code)               // 11
//                let task = urlSession.dataTask(with: request) { data, response, error in
//                    DispatchQueue.main.async {                      // 12
//                        completion(.success("")) // TODO [Sprint 10]// 13
//                        self.task = nil                             // 14
//                        if error != nil {                           // 15
//                            self.lastCode = nil                     // 16
//                        }
//                    }
//                }
//                self.task = task                                    // 17
//                task.resume()                                       // 18
//    }
//
//        let url = "https://unsplash.com/me"
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//            if let error = error {
//                handler(.failure(error))
//                return
//            }
//
//            if let response = response as? HTTPURLResponse,
//                response.statusCode < 200 || response.statusCode >= 300 {
//                handler(.failure(NetworkError.codeError))
//                return
//            }
//
//
//            guard let data = data else { return }
//            handler(.success(data))
//        }
//
//        task.resume()
//
//}


