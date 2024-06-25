//
//  IconTableViewCell.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

class IconTableViewCell: UITableViewCell {
    
    private let fontSize: CGFloat = 16
    private let spacing: CGFloat = 8
    private let inset: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let buttonSide: CGFloat = 30
    
    private lazy var mainBackground: UIView = {
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var iconView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: SearchStrings.Image.defaultImage)
        $0.layer.cornerRadius = cornerRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var downloadLabel: UILabel = {
        $0.text = SearchStrings.Title.download
        $0.font = .italicSystemFont(ofSize: 12)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var sizeLabel: UILabel = {
        $0.text = SearchStrings.Title.maxSize
        $0.font = .systemFont(ofSize: fontSize, weight: .medium)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var sizeValueLabel: UILabel = {
        $0.font = .systemFont(ofSize: fontSize, weight: .regular)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var tagLabel: UILabel = {
        $0.text = SearchStrings.Title.tags
        $0.font = .systemFont(ofSize: fontSize, weight: .medium)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var tagValueLabel: UILabel = {
        $0.numberOfLines = .zero
        $0.font = .systemFont(ofSize: fontSize, weight: .regular)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var sizeStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = spacing
        $0.alignment = .top
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var tagStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = spacing
        $0.alignment = .top
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = spacing
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var favoriteButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        addConstraints()
        contentView.backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        iconView.image = UIImage(named: SearchStrings.Image.defaultImage)
    }
    
    private func addSubviews() {
        sizeStackView.addArrangedSubview(sizeLabel)
        sizeStackView.addArrangedSubview(sizeValueLabel)
        
        tagStackView.addArrangedSubview(tagLabel)
        tagStackView.addArrangedSubview(tagValueLabel)
        
        infoStackView.addArrangedSubview(sizeStackView)
        infoStackView.addArrangedSubview(tagStackView)
        
        mainBackground.addSubview(favoriteButton)
        mainBackground.addSubview(iconView)
        mainBackground.addSubview(downloadLabel)
        mainBackground.addSubview(infoStackView)
        
        contentView.addSubview(mainBackground)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            mainBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconView.topAnchor.constraint(equalTo: mainBackground.topAnchor, constant: inset),
            iconView.leadingAnchor.constraint(equalTo: mainBackground.leadingAnchor, constant: inset*8),
            iconView.trailingAnchor.constraint(equalTo: mainBackground.trailingAnchor, constant: -inset*8),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor, multiplier: 1),
            
            favoriteButton.topAnchor.constraint(equalTo: mainBackground.topAnchor, constant: inset),
            favoriteButton.trailingAnchor.constraint(equalTo: mainBackground.trailingAnchor, constant: -inset),
            favoriteButton.widthAnchor.constraint(equalToConstant: buttonSide),
            favoriteButton.heightAnchor.constraint(equalToConstant: buttonSide),
            
            downloadLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 2),
            downloadLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: downloadLabel.bottomAnchor, constant: inset),
            infoStackView.bottomAnchor.constraint(equalTo: mainBackground.bottomAnchor, constant: -inset),
            infoStackView.leadingAnchor.constraint(equalTo: mainBackground.leadingAnchor, constant: inset),
            infoStackView.trailingAnchor.constraint(equalTo: mainBackground.trailingAnchor, constant: -inset)
        ])
    }
    
    func configure(_ model: IconViewModel) {
        if let image = model.image {
            iconView.image = image
        }
        sizeValueLabel.text = model.size
        tagValueLabel.text = model.tags
    }
    
    func configureButton(target: Any?, action: Selector) {
        favoriteButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func configureButton(image: UIImage?, tag: Int) {
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tag = tag
    }
}
