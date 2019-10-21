//
//  FooterLoading.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 20.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import UIKit

class FooterLoading: UIView {
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElements() {
        addSubview(loadingLabel)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
        
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8)
        ])
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
        loadingLabel.text = "Loading"
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
        loadingLabel.text = ""
    }
}
