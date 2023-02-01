//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 03/01/2023.
//

import Foundation
import WebKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service()
    private var oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        self.oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.oAuth2TokenStorage.token = token
                    self.delegate?.authViewController(self, didAuthenticateWithCode: token)
                    self.webViewViewControllerDidCancel(vc)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
