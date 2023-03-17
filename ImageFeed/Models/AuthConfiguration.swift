//  Constants.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 02/01/2023.
//

import Foundation

let AccessKey = "Gbw9y_w3yiafGdKoQ9NUMG6vKdjnsKRx1nbwoGIe6OM"
let SecretKey = "gsYaWk6sp-JW2yNKO_hKHGdRSpOvfZiNncHkYw7xirI"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let AuthorizeURL = "https://unsplash.com/oauth/authorize"

let TokenURL = "https://unsplash.com/oauth/token"
let BaseURL = "https://api.unsplash.com"
let ProfileURL = "\(BaseURL)/me"
let ProfileImageURL = "\(BaseURL)/users"


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authorizeURL: String
    
    let tokenURL: String
    let baseURL: String
    let profileURL: String
    let profileImageURL: String
    
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authorizeURL: String, tokenURL: String, baseURL: String, profileURL: String, profileImageURL: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authorizeURL = authorizeURL
        
        self.tokenURL = tokenURL
        self.baseURL = baseURL
        self.profileURL = profileURL
        self.profileImageURL = profileImageURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 authorizeURL: AuthorizeURL,
                                 tokenURL: TokenURL,
                                 baseURL: BaseURL,
                                 profileURL: ProfileURL,
                                 profileImageURL: ProfileImageURL)
    }
}

