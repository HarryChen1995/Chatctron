//
//  HomeViewController.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/4/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
import Firebase


class CustomTitleView : UIView {
    var navigationController: UINavigationController?
    let titleLoadindicator: UIActivityIndicatorView  = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .large
        indicatorView.color = .white
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    lazy var logoutButton : UIButton = {
        let button  = UIButton()
        button.setImage(UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(logout) , for: .touchUpInside )
        return button
    }()
    
    @objc func logout() {
        do  {
        try Auth.auth().signOut()
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }catch {
            return
        }
    }
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
            
    }()
    
    
    let profileImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 35/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    
        
        addSubview(label)
        addSubview(profileImageView)
        addSubview(titleLoadindicator)
        addSubview(logoutButton)
        

        addConstraintsWithFormat(format: "H:|-10-[v0(35)]-30-[v1(150)]-80-[v2(25)]", views: profileImageView, label, logoutButton)
        addConstraintsWithFormat(format: "V:|-5-[v0(35)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-5-[v0(35)]", views: label)
        addConstraintsWithFormat(format: "V:|-10-[v0(25)]", views: logoutButton)
        
        
        let constraints = [
            titleLoadindicator.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            titleLoadindicator.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            titleLoadindicator.widthAnchor.constraint(equalToConstant: 35),
            titleLoadindicator.heightAnchor.constraint(equalToConstant: 35)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        fetchProfileImage()
        fetchName()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
    
    
    private func fetchProfileImage(){
         let userID = Auth.auth().currentUser?.uid
        let ref = Storage.storage().reference()
        let pathref = ref.child("image/\(userID!).png")
        pathref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
        if let error = error {
            print(error)
        } else {
            let image = UIImage(data: data!)?.withRenderingMode(.alwaysOriginal)
            self.profileImageView.image = image
            
            }}
        
    }
    
    private func fetchName(){
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(userID!).getDocument(completion: {
            (document, error) in
            
            if error != nil {
                print(error!)
            }else{
                if let document = document, document.exists {
                    if let data = document.data() {
                        self.titleLoadindicator.stopAnimating()
                        self.label.text = (data["firstName"] as! String) + " " + (data["lastName"] as! String)
                    }
                }
            }
            
        })

    }
    
}


class HomeViewController : UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .primaryColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let titleView = CustomTitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 90)
        titleView.navigationController = navigationController
        navigationItem.titleView = titleView
    }
    
}

    
