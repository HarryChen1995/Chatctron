//
//  FriendCell.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/5/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class FriendCell : BaseTableCell {
    
    var user: User? {
        didSet {
            userName.backgroundColor = .clear
            userName.text = user!.firstName + " " + user!.lastName
            profileImageView.image = user!.profileImage
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .primaryColor
        return imageView
    }()
    
    let userName : UILabel = {
        
        let label = UILabel()
        label.textColor = .primaryColor
        label.backgroundColor = .primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override func setupCell(){
        super.setupCell()
        addSubview(profileImageView)
        addSubview(userName)
        addConstraintsWithFormat(format: "H:|-20-[v0(50)]-20-[v1(200)]", views: profileImageView, userName)
        addConstraintsWithFormat(format: "V:|-20-[v0(50)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-29-[v0(30)]", views: userName)
        
        
        
    }
}
