//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Marina Kolbina on 26/02/2023.
//
@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {
    
    private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    
    func testExample() throws {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage(oAuth2TokenStorage.token!)
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}

