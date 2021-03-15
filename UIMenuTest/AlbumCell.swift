//
//  AlbumCell.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 14.03.2021.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    static let reuseIdetifire: String = "album-cell-reuse-identifier"
    let imageView = MyUmageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumCell {
    private func configurate() {
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        let insets: CGFloat = 5.0
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets)

        ])
    }
}
