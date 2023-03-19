//
//  Profile_ImageListView_s_Tests.swift
//  Profile&ImageListView's Tests
//
//  Created by Marina Kolbina on 19/03/2023.
//

import XCTest
@testable import ImageFeed

final class Profile_ImageListView_s_Tests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let presenter = ImagesListViewPresenterSpy()
        let viewController = ImagesListViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsViewDidLoad2() {
            // given
            let viewController = ProfileViewController()
            let presenter = ProfileViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
            
            // when
            _ = viewController.view
            
            // then
            XCTAssertTrue(presenter.viewDidLoadCalled)
        }
}

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func makeAlert() -> UIAlertController {
        UIAlertController()
    }
}
