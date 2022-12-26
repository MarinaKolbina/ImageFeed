//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 22/12/2022.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            imageView.image = image
        }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
