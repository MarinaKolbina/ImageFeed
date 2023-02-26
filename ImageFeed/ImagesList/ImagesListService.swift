//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 22/02/2023.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    //    static let shared = ImageListService()
    
    func fetchPhotosNextPage(_ token: String) {
        let session = URLSession.shared
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        let request = makeRequest(token: token, page: nextPage)
        guard let request = request else { return }
        if task == nil {
            task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let photoResults):
                    self.appendNewPhotos(data: photoResults)
                    self.lastLoadedPage = nextPage
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
        
        else {
            return
        }
    }
    
    private func appendNewPhotos(data: [PhotoResult]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let newPhotos = data.map {
                Photo(id: $0.id,
                      height: $0.height,
                      width: $0.width,
                      createdAt: $0.createdAt,
                      welcomeDescription: $0.description,
                      thumbImageURL: $0.urls.thumb,
                      largeImageURL: $0.urls.full,
                      isLiked: $0.isLiked)}
            
            self.photos.append(contentsOf: newPhotos)
            
            NotificationCenter.default
                .post(
                    name: ImagesListService.DidChangeNotification,
                    object: self
                )
        }
    }
    
    
    private func makeRequest(token: String, page: Int, per_page: Int = 10) -> URLRequest? {
        if var urlComponents = URLComponents(string: "\(Constants.baseURL)/photos") {
            urlComponents.queryItems = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(per_page))
            ]
            var request = URLRequest(url: urlComponents.url!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            return request
        }
        return nil
    }
    
}
