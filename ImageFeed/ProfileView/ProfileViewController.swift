//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 09/12/2022.
//

import Foundation
import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private let imageView = UIImageView(image: UIImage(named: "userpick"))
    private let nameSurname = UILabel()
    private let username = UILabel()
    private let profileDescription = UILabel()
    
    private let logOutButton = UIButton.systemButton(
        with: UIImage(named: "logout_button")!,
        target: self,
        action: #selector(Self.didTapButton)
    )
    private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?      // 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameSurname.text = "Екатерина Новикова"
        nameSurname.font = UIFont(name:"HelveticaNeue-Bold", size: 23.0)
        nameSurname.textColor = UIColor(named: "YP White")
        nameSurname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameSurname)
        nameSurname.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameSurname.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        
        username.text = "@ekaterina_nov"
        username.font = UIFont(name:"HelveticaNeue", size: 13.0)
        username.textColor = UIColor(named: "YP Grey")
        username.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(username)
        username.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        username.topAnchor.constraint(equalTo: nameSurname.bottomAnchor, constant: 8).isActive = true
        
        profileDescription.text = "Hello, world!"
        profileDescription.font = UIFont(name:"HelveticaNeue", size: 13.0)
        profileDescription.textColor = UIColor(named: "YP White")
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescription)
        profileDescription.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        profileDescription.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 8).isActive = true
        
        logOutButton.tintColor = .red
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        profileService.fetchProfile(oAuth2TokenStorage.token!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(profile):
                self.nameSurname.text = profile.username
                self.username.text = profile.username
                self.profileDescription.text = profile.bio
            case let .failure(error):
                // TODO [Sprint 11] Показать ошибку
                break
            }
            
        }
        
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.DidChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        updateAvatar()
    }
    
    func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "userpick"),
                              options: [.transition(.fade(1)),
                                        .cacheOriginalImage
                              ])
    }
    
    func onLogout() {
        OAuth2TokenStorage().clearToken()
        print("2")
        WebViewViewController.cleanCookies()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
        print("3")
        print(4)
    }
    
    @objc
    private func didTapButton() {
        print("1")
        onLogout()
    }
}
