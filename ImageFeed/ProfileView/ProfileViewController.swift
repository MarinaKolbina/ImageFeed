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
    
    private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?      // 1


    override func viewDidLoad() {
        let profileImage = UIImage(named: "userpick")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let label1 = UILabel()
        label1.text = "Екатерина Новикова"
        label1.font = UIFont(name:"HelveticaNeue-Bold", size: 23.0)
        label1.textColor = UIColor(named: "YP White")
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        label1.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        let label2 = UILabel()
        label2.text = "@ekaterina_nov"
        label2.font = UIFont(name:"HelveticaNeue", size: 13.0)
        label2.textColor = UIColor(named: "YP Grey")
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)
        label2.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8).isActive = true
        
        let label3 = UILabel()
        label3.text = "Hello, world!"
        label3.font = UIFont(name:"HelveticaNeue", size: 13.0)
        label3.textColor = UIColor(named: "YP White")
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        label3.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 8).isActive = true
        
        
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        profileService.fetchProfile(oAuth2TokenStorage.token!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(profile):
                label1.text = profile.username
                label2.text = profile.username
                label3.text = profile.bio
            case let .failure(error):
                // TODO [Sprint 11] Показать ошибку
                break
            }
            
        }
        
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.DidChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()                                 // 6
            }
        updateAvatar()
        
        
        
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
    
    }
    
    @objc
    private func didTapButton() {
    }
}
