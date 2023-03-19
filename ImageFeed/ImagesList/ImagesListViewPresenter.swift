//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 17/03/2023.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}

class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    var imageListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        observeImagesLoad()
    }
    
    func observeImagesLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            }
        
    }
    
}
