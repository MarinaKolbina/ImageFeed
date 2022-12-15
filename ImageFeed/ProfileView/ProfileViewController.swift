//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 09/12/2022.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
    
}
