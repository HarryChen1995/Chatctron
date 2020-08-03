//
//  ProgressWindow.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/3/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit


class  ProgressWindow : NSObject {
    var label: String?
    let blackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    let activityIndicator: UIActivityIndicatorView =  {
       let indicator  = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.startAnimating()
        return indicator
    }()
    let labelView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    func setupBlackView (){
        blackView.addSubview(whiteView)
        blackView.addSubview(activityIndicator)
        whiteView.addSubview(labelView)
        labelView.text = label
        let constraints = [
            whiteView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
            whiteView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
            whiteView.widthAnchor.constraint(equalToConstant: 220),
            whiteView.heightAnchor.constraint(equalToConstant: 220),
            activityIndicator.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: blackView.centerYAnchor, constant: 30),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            labelView.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: whiteView.topAnchor, constant: 70),
            labelView.widthAnchor.constraint(equalToConstant: 200),
            labelView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    func showProgress(){
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            blackView.frame = window.frame
            setupBlackView()
            window.addSubview(blackView)
        }
        
    }
    
    func dissmisProgress() {
        blackView.alpha = 0
        whiteView.alpha = 0
        activityIndicator.stopAnimating()
        labelView.isHidden = true
    }
}
