//
//  StockCell.swift
//  Ticker365
//
//  Created by EDGARDO AGNO on 17/07/2024.
//

import UIKit

class StockCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let companyNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(nameLabel)
        addSubview(companyNameLabel)
        addSubview(priceLabel)
        addSubview(changeLabel)
        
        // Configure labels layout here
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -10),

            companyNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            companyNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: changeLabel.leadingAnchor, constant: -10),

            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            changeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        // Configure colors for dark mode and light mode
        nameLabel.textColor = .label
        companyNameLabel.textColor = .label
        priceLabel.textColor = .label
        changeLabel.textColor = .label

        // Style the cell
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 8
    }

    func configure(with stock: Stock, isChanged: Bool = false) {
        nameLabel.text = stock.name
        companyNameLabel.text = stock.companyName
        priceLabel.text = stock.priceDisplayed
        changeLabel.text = stock.changeDisplayed
        
        // Change color of changeLabel based on value
        if stock.change >= 0 {
            changeLabel.textColor = .systemGreen
        } else {
            changeLabel.textColor = .systemRed
        }
        
        if isChanged {
            animatePriceChange()
        }
    }
    
    private func animatePriceChange() {
        UIView.animate(withDuration: 0.2, animations: {
            self.priceLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.priceLabel.transform = CGAffineTransform.identity
            })
        }
    }
}

extension Stock {
    var priceDisplayed: String { String(format: "%.2f", price) }
    
    var changeDisplayed: String { String(format: "%.2f", change) }
}
