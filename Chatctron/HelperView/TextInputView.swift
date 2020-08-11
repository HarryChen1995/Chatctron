//
//  TextInputView.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/11/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class TextInputView: UIView {
    
    
    let textView: UITextView = {
       let textview = UITextView()
        textview.layer.cornerRadius = 12
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.primaryColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.9, alpha: 1)
        setupTextInputView()
    }
    
    func setupTextInputView() {
        
        addSubview(textView)
        addSubview(sendButton)
        
        
        let constraints = [
        
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            textView.widthAnchor.constraint(equalToConstant: 300),
            
            
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            sendButton.widthAnchor.constraint(equalToConstant: 45),
        
        
        ]
        
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
