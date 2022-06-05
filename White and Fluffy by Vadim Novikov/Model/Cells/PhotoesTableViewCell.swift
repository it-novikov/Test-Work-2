//
//  PhotoesTableViewCell.swift
//  White and Fluffy by Vadim Novikov
//
//  Created by Vadim Novikov on 05.06.2022.
//

import UIKit
import SDWebImage

final class PhotoesTableViewCell: UITableViewCell {
    
    static let reuseId = "ImageCell"
    
    var singleImage: SingleImage! {
        didSet {
            let singleImageUrl = singleImage.urls["regular"]
            guard let imageUrl = singleImageUrl, let url = URL(string: imageUrl) else { return }
            photoView.sd_setImage(with: url, completed: nil)
        }
    }
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    private func setConstraints() {
        addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            photoView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}

