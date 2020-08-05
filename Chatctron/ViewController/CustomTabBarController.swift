//
//  CustomTabViewController.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/5/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homevc = UINavigationController(rootViewController: HomeViewController())
        homevc.tabBarItem.title = "Friends"
        homevc.tabBarItem.image =  UIImage(named: "people")
        
        
        
        let chatvc = UINavigationController(rootViewController: ChatViewController())
        chatvc.tabBarItem.title = "Chats"
        chatvc.tabBarItem.image =  UIImage(named: "chat")
 
        viewControllers = [
            homevc,
            chatvc
    ]
        
    }
    
    
}
