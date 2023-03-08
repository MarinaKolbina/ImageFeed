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
    
    @IBOutlet weak var ShareButton: UIButton!
    
    
    var imageUrl: URL! {
        didSet {
            guard isViewLoaded else { return }
            setImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.image = image
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
//        rescaleAndCenterImageInScrollView(image: image)
        setImage()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageView.image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError () {
        let error = UIAlertController(
                title: "Что-то пошло не так",
                message: "Попробовать ещё раз?",
                preferredStyle: .alert
            )

            let dismissAction = UIAlertAction(
                title: "Не надо",
                style: .default
            ) { _ in
                error.dismiss(animated: true)
            }

            let retryAction = UIAlertAction(
                title: "Попробовать еше раз?",
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.setImage()
            }
            error.addAction(dismissAction)
            error.addAction(retryAction)

            self.present(error, animated: true)
    }
}
    
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

