//
//  Models.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 18/01/2023.
//

import Foundation

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

struct Badge: Codable {
    let title: String
    let primary: Bool
    let slug: String
    let link: String
}

struct Links: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct Social: Codable {
    let instagramUsername, portfolioURL, twitterUsername: String

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
    }
}

struct UserResult: Codable {
    let id: String
    let updatedAt: Date
    let username, name, firstName, lastName: String
    let instagramUsername, twitterUsername: String
    let portfolioURL: String
    let bio, location: String
    let totalLikes, totalPhotos, totalCollections: Int
    let followedByUser: Bool
    let followersCount, followingCount, downloads: Int
    let social: Social
    let profileImage: ProfileImage
    let badge: Badge
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case downloads, social
        case profileImage = "profile_image"
        case badge, links
    }
}

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
}
