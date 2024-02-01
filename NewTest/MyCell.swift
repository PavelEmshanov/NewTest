//
//  MyCell.swift
//  NewTest
//
//  Created by D. P. on 31.01.2024.
//

import UIKit

class MyCell: UITableViewCell {
    init(with notes: Notes) {
        super.init(style: .default, reuseIdentifier: "MyCell")
        
        backgroundColor = .tertiarySystemFill
        let titleLabel = UILabel()
        if let title = notes.title {
            titleLabel.text = title
            titleLabel.font = .boldSystemFont(ofSize: 17)
        }
        let dateLabel = UILabel()
        dateLabel.text = notes.date?.formatted().components(separatedBy: ",").first
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.layer.borderWidth = 0.6
        dateLabel.layer.cornerRadius = 6
        dateLabel.layer.borderColor = CGColor(gray: 1, alpha: 1)
        dateLabel.textAlignment = .center
        
        let descriptionLabel = UILabel()
        if let description = notes.text {
            descriptionLabel.text = description
            descriptionLabel.font = .systemFont(ofSize: 13)
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        
        let constraints = [
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 55),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
            
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            dateLabel.widthAnchor.constraint(equalToConstant: 80),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
