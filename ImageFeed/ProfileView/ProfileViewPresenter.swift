//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 16/03/2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?      // 1
    
    func viewDidLoad() {
        
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.DidChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()                           // 6
            }
        view?.updateAvatar()
    }


}
