//
//  PhotoView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-06.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit
#if os(tvOS)
import TVUIKit
#endif

class PhotoView: UIView {

    private var currentPhotoID: String?
    private var imageDownloader = ImageDownloader()
    private var screenScale: CGFloat { return UIScreen.main.scale }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var overlayViews: [UIView]!
#if os(tvOS)
    @IBOutlet private weak var tvPosterView: TVPosterView!
#endif
    var showsUsername = true {
        didSet {
            userNameLabel.alpha = showsUsername ? 1 : 0
            gradientView.alpha = showsUsername ? 1 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        accessibilityIgnoresInvertColors = true
        gradientView.setColors([
            GradientView.Color(color: .clear, location: 0),
            GradientView.Color(color: UIColor(white: 0, alpha: 0.5), location: 1)
        ])
    }

    func prepareForReuse() {
        currentPhotoID = nil
        userNameLabel.text = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let fontSize: CGFloat = traitCollection.horizontalSizeClass == .compact ? 10 : 13
        userNameLabel.font = UIFont.systemFont(ofSize: fontSize)
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto, showsUsername: Bool = true) {
        self.showsUsername = showsUsername
        userNameLabel.text = photo.user.displayName
        imageView.backgroundColor = photo.color
        currentPhotoID = photo.identifier
        downloadImage(with: photo)
#if os(tvOS)
        tvPosterView.imageView.image = imageView.image
        tvPosterView.title = userNameLabel.text
        userNameLabel.isHidden = true
        imageView.isHidden = true
#endif
    }

    private func downloadImage(with photo: UnsplashPhoto) {
        guard let regularUrl = photo.urls[.regular] else { return }

        let url = sizedImageURL(from: regularUrl)

        let downloadPhotoID = photo.identifier

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let self, self.currentPhotoID == downloadPhotoID else { return }

            if isCached {
                self.imageView.image = image
            } else {
                UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.imageView.image = image
                }, completion: nil)
            }
        })
    }

    private func sizedImageURL(from url: URL) -> URL {
        layoutIfNeeded()
        return url.appending(queryItems: [
            URLQueryItem(name: "w", value: "\(frame.width)"),
            URLQueryItem(name: "dpr", value: "\(Int(screenScale))")
        ])
    }

    // MARK: - Utility

    class func view(with photo: UnsplashPhoto) -> PhotoView? {
        guard let photoView = Configuration.shared.photoViewNib?.instantiate(withOwner: nil, options: nil).first as? PhotoView else {
            return nil
        }

        photoView.configure(with: photo)

        return photoView
    }

}
