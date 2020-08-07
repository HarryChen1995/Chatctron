//
//  ProfileViewController.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/5/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class ChatLogController: UIViewController {
    var firstName: String?
    var lastName: String?
    var userID: String?
    var email: String?
    var profileImage:UIImage?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = profileImage
        imageView.backgroundColor = .primaryColor
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = firstName! + " " +  lastName!
        label.textAlignment = .center
        label.textColor = .primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = ": " + email!
        label.textColor = .primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let  emailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addBlurEffectToNavBar()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        navigationItem.title = firstName! + " " +  lastName!
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailIcon)
        
        let constraints = [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 70),
            nameLabel.widthAnchor.constraint(equalToConstant: 200),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 40),
            
            emailIcon.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailIcon.trailingAnchor.constraint(equalTo: emailLabel.leadingAnchor, constant: -2),
            emailIcon.widthAnchor.constraint(equalToConstant: 20),
            emailIcon.heightAnchor.constraint(equalTo: emailIcon.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
}
