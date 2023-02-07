//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 09/12/2022.
//

import Foundation
import UIKit

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
    }
    
    @objc
    private func didTapButton() {
    }
}
