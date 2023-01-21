//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 19/01/2023.
//

import Foundation
import UIKit

class AlertPresenter {
    weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentAlert(model: AlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: model.buttonText, style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        viewController?.present(alertController, animated: true)
    }
}
