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
    static let shared = ImagesListService()
    
    func fetchPhotosNextPage(_ token: String) {
        let session = URLSession.shared
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        let request = makeRequest(token: token, page: nextPage)
        guard let request = request else { return }
        if task == nil {
            let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
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
            task.resume()
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
    
    func changeLike(token: String, photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let session = URLSession.shared
        let request = makeRequest(token: token, photoId: photoId, isLike: isLike)
        guard let request = request else { return }
        if task == nil {
            let task = session.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let likePhotoResults):
                    self.updatePhotoInfo(photoId: photoId)
                    print("changed like on \(likePhotoResults.photo.id)")
                case .failure(let error):
                    print(error)
                }
            }
            task.resume()
        }

        else {
            return
        }
    }
//
    func updatePhotoInfo(photoId: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                let photo = self.photos[index]
                
                let newPhoto = Photo(
                    id: photo.id,
                    height: Int(photo.size.height),
                    width: Int(photo.size.width),
                    createdAt: ISO8601DateFormatter().string(from: photo.createdAt ?? Date()),
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !photo.isLiked
                )
                self.photos[index] = newPhoto
            }
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
    
    
    
    private func makeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest? {
        if var urlComponents = URLComponents(string: "\(Constants.baseURL)/photos/\(photoId)/like") {
            urlComponents.queryItems = [
                URLQueryItem(name: "id", value: photoId)
            ]
            var request = URLRequest(url: urlComponents.url!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            if isLike {
                request.httpMethod = "DELETE"
            }
            else {
                request.httpMethod = "POST"
            }
            return request
        }
        return nil
    }
    
}
