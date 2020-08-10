//
//  MessageCell.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/10/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit


class MessageCell: BaseTableCell {
    let messageLabel: UILabel =  {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    return label
    }()
    
    let bubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let profileimageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override func setupCell() {
        super.setupCell()
        addSubview(bubbleView)
        addSubview(messageLabel)
        addSubview(profileimageView)
        selectionStyle = .none
        let constraints = [

            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20+32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            
            
            profileimageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            profileimageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileimageView.widthAnchor.constraint(equalToConstant: 20),
            profileimageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
}
