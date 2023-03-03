//
//  Models.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 18/01/2023.
//

import Foundation

struct ProfileResult: Codable {
    var username: String
    var first_name: String
    var last_name: String
    var bio: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        first_name = try container.decode(String.self, forKey: .first_name)
        last_name = try container.decode(String.self, forKey: .last_name)
        bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
        username = try container.decode(String.self, forKey: .username)
    }
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

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    var isLiked: Bool
    let description: String?
    let urls: UrlsResult
    
    enum UrlsKeys: String, CodingKey {
        case full, small, thumb
    }
    
    struct UrlsResult: Codable {
        let full: String
        let small: String
        let thumb: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls
        case isLiked = "liked_by_user"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        isLiked = try container.decode(Bool.self, forKey: .isLiked)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        
        urls = try container.decode(UrlsResult.self, forKey: .urls)
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}

struct Photo: Decodable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(id: String, height: Int, width: Int, createdAt: String, welcomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        let formatter = ISO8601DateFormatter()
        self.id = id
        self.size = CGSize(width: width, height: height)
        self.createdAt = formatter.date(from: createdAt) ?? Date()
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
