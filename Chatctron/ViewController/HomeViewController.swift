//
//  HomeViewController.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/4/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

let imageCache = NSCache<NSString, UIImage>()
let nameCache = NSCache<NSString, NSString>()

class CustomTitleView : UIView {
    var navigationController: UINavigationController?
    let titleLoadindicator: UIActivityIndicatorView  = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .medium
        indicatorView.color = .primaryColor
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    let imageLoadindicator: UIActivityIndicatorView  = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .medium
        indicatorView.color = .primaryColor
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    lazy var logoutButton : UIButton = {
        let button  = UIButton()
        button.setImage(UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .primaryColor
        button.addTarget(self, action: #selector(logout) , for: .touchUpInside )
        return button
    }()
    
    @objc func logout() {
        do  {
        try Auth.auth().signOut()
        usersCache.removeAllObjects()
        let LoginVC = LoginViewController()
        navigationController?.pushViewController(LoginVC, animated: true)
        }catch {
            return
        }
    }
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
            
    }()
    
    
    let profileImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(imageLoadindicator)
        

        addConstraintsWithFormat(format: "H:|-10-[v0(35)]-30-[v1(150)]-80-[v2(25)]", views: profileImageView, label, logoutButton)
        addConstraintsWithFormat(format: "V:|-5-[v0(35)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-5-[v0(35)]", views: label)
        addConstraintsWithFormat(format: "V:|-10-[v0(25)]", views: logoutButton)
        
        
        let constraints = [
            titleLoadindicator.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            titleLoadindicator.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            titleLoadindicator.widthAnchor.constraint(equalToConstant: 10),
            titleLoadindicator.heightAnchor.constraint(equalToConstant: 10),
            
            imageLoadindicator.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            imageLoadindicator.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            imageLoadindicator.widthAnchor.constraint(equalTo: profileImageView.widthAnchor),
            imageLoadindicator.heightAnchor.constraint(equalTo: profileImageView.heightAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        fetchProfileInfo()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
    func fetchProfileInfo(){
        if let userID = Auth.auth().currentUser?.uid, let image = imageCache.object(forKey: "\(userID).png" as NSString) , let name = nameCache.object(forKey: "\(userID).name" as NSString) {
            profileImageView.image = image
            label.text = name as String
            titleLoadindicator.stopAnimating()
            imageLoadindicator.stopAnimating()
        }
        else{
        fetchProfileImage()
        fetchName()
        }
        
    }
    
    private func fetchProfileImage(){
         let userID = Auth.auth().currentUser?.uid
        let ref = Storage.storage().reference()
        let pathref = ref.child("image/\(userID!).png")
        pathref.getData(maxSize: .max) { (data, error) in
        if let error = error {
            print(error)
        } else {
            let image = UIImage(data: data!)?.withRenderingMode(.alwaysOriginal)
            self.imageLoadindicator.stopAnimating()
            self.profileImageView.image = image
            imageCache.setObject(image!, forKey: "\(userID!).png" as NSString)
            
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
                        nameCache.setObject(self.label.text! as NSString, forKey: "\(userID!).name" as NSString)
                    }
                }
            }
            
        })

    }
    
}

let usersCache = NSCache<NSString, NSArray>()

class HomeViewController : UITableViewController {

    let ID = "Friend"
    var users: [User] = []
    var userID:String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.addBlurEffectToNavBar()
        tabBarController?.tabBar.isHidden = false
    }
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let titleView = CustomTitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 90)
        titleView.navigationController = navigationController
        navigationItem.titleView = titleView
        tableView.tableFooterView = UIView()
        tableView.register(FriendCell.self, forCellReuseIdentifier: ID)
        tableView.isUserInteractionEnabled = false
        fetchFriend()
        tableView.isUserInteractionEnabled = true
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let profileviewvc =  ProfileViewController()
        profileviewvc.firstName = user.firstName
        profileviewvc.lastName = user.lastName
        profileviewvc.userID  = user.userID
        profileviewvc.email = user.email
        navigationController?.pushViewController(profileviewvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! FriendCell
        
        cell.user = users[indexPath.row]
        return cell
    }
    
    
    func fetchFriend(){
     if let u = usersCache.object(forKey: "users") as? [User] , u.count != 0{
        users = u
       }else{
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                self.users.removeAll()
                if  document.documentID  != Auth.auth().currentUser?.uid{
                    
                    let data = document.data()
                    let user = User(userID: document.documentID, firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, email: data["email"] as! String)
                    self.users.append(user)
                    
                }
                usersCache.setObject(self.users as NSArray, forKey: "users" as NSString)
                self.tableView.reloadData()
            }
            
        }
        
    }
        
        print(users.count)
        
        }
        
    }
    
    
    
}

    
