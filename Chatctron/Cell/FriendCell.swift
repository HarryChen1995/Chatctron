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

let profileimageCache  =  NSCache<NSString, UIImage>()

class FriendCell : BaseTableCell {
    
    var user: User? {
        didSet {
            userName.backgroundColor = .clear
            userName.text = user!.firstName + " " + user!.lastName
            fetchProfileImage(userID: user!.userID)
        }
    }
    
    
    private func fetchProfileImage(userID:String){
        
        if let image = profileimageCache.object(forKey: "\(userID).png" as NSString)
        {
            profileImageView.backgroundColor = .clear
            profileImageView.image = image
        }
        else {
        let ref = Storage.storage().reference()
        let pathref = ref.child("image/\(userID).png")
        pathref.getData(maxSize: .max) { (data, error) in
        if let error = error {
            print(error)
        } else {
            let image = UIImage(data: data!)?.withRenderingMode(.alwaysOriginal)
            profileimageCache.setObject(image!, forKey: "\(userID).png" as NSString)
            self.profileImageView.backgroundColor = .clear
            self.profileImageView.image = image
            
            }}
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
