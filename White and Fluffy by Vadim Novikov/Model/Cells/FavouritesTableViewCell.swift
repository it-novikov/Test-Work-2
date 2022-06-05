//
//  FavouritesTableViewCell.swift
//  White and Fluffy by Vadim Novikov
//
//  Created by Vadim Novikov on 05.06.2022.
//

import UIKit

final class FavouritesTableViewCell: UITableViewCell {
    
    static let reuseId = "FavouriteCell"
    
    var favouriteImage: DetailedImage! {
        didSet {
            let favouriteImageUrl = favouriteImage.urls["thumb"]
            guard let imageUrl = favouriteImageUrl, let url = URL(string: imageUrl) else { return }
            smallImageView.sd_setImage(with: url, completed: nil)
            smallAuthorLabel.text = favouriteImage.user.name
        }
    }
    
    private lazy var smallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var smallAuthorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - setConstraints
    
    private func setConstraints() {
        addSubview(smallImageView)
        addSubview(smallAuthorLabel)
        
        NSLayoutConstraint.activate([
            smallImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            smallImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            smallImageView.widthAnchor.constraint(equalToConstant: 100),
            smallImageView.heightAnchor.constraint(equalToConstant: 40),
            
            smallAuthorLabel.heightAnchor.constraint(equalToConstant: 40),
            smallAuthorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            smallAuthorLabel.leadingAnchor.constraint(equalTo: smallImageView.trailingAnchor, constant: 15),
            smallAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
}
