//
//  Constants.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 02/01/2023.
//

import Foundation

enum Constants {
    static let accessKey = "Gbw9y_w3yiafGdKoQ9NUMG6vKdjnsKRx1nbwoGIe6OM"
    static let secretKey = "gsYaWk6sp-JW2yNKO_hKHGdRSpOvfZiNncHkYw7xirI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let authorizeURL = "https://unsplash.com/oauth/authorize"
    static let tokenURL = "https://unsplash.com/oauth/token"
}
