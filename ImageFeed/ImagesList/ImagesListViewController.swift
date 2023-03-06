import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var photosName = [String]()
    private var photos: [Photo] = []
    
    @IBOutlet private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeImagesLoad()
        imagesListService.fetchPhotosNextPage(oauth2TokenStorage.token!)
        photosName = Array(0..<20).map{ "\($0)" }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage(oauth2TokenStorage.token!)
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func observeImagesLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        imageListCell.cellImage.kf.indicatorType = .activity
        imageListCell.cellImage.kf.setImage(with: URL(string: photos[indexPath.row].thumbImageURL),
                                            placeholder: UIImage(named: "mockImagesForTable/0"),
                                            options: [.transition(.fade(1)),
                                                      .cacheOriginalImage
                                            ]) { result in
            switch result {
            case .success(_):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
}


extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row % photosName.count]) else {
            return
        }
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
//        let isLiked = indexPath.row % 2 == 0
        let likeImage = UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(token: oauth2TokenStorage.token!, photoId: photo.id, isLike: !photo.isLiked) {
            result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
            case .failure:
                print("")
                // TODO: Показать ошибку с использованием UIAlertController
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
