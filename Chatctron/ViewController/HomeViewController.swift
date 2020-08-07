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

let usersCache = NSCache<NSString, NSArray>()

class HomeViewController : UITableViewController {
    
    let loadingIndicator: UIActivityIndicatorView  = {
        let  indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private func fetchUserProfileImage (userID:String, completion: @escaping(UIImage)->Void){
        let ref = Storage.storage().reference()
        let pathref = ref.child("image/\(userID).png")
        pathref.getData(maxSize: .max) { (data, error) in
            if let error = error {
                print(error)
            } else {
                
                let image = UIImage(data: data!)?.withRenderingMode(.alwaysOriginal)
                completion(image!)
                self.tableView.reloadData()
            }}
    }
    private func fetchUsers(){
        if let u = usersCache.object(forKey: "users") as? [User] , u.count != 0{
            self.users = u
            loadingIndicator.stopAnimating()
        }else{
            let db = Firestore.firestore()
            db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if document.documentID != Auth.auth().currentUser?.uid  {
                            let data = document.data()
                            let user = User(userID: document.documentID, firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, email: data["email"] as! String)
                            self.fetchUserProfileImage(userID: user.userID,completion:  {
                                (image) in
                                user.profileImage = image
                            }
                            )
                            self.users.append(user)
                        }
                    }
                    usersCache.setObject(self.users as NSArray, forKey: "users" as NSString)
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                }
            }
            
        }
    }
    
    
    
    
    
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
    
    let sideMenu = SideMenu()
    @objc func displaySideMenu (){
        sideMenu.showSideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.setup()
        view.backgroundColor = .white
        navigationItem.title = "Friends"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(displaySideMenu))
        
        tableView.tableFooterView = UIView()
        tableView.register(FriendCell.self, forCellReuseIdentifier: ID)
        setupLoadingIndicator()
        fetchUsers()
        
        
    }
    
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor).isActive = true
        
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
        profileviewvc.profileImage = user.profileImage
        navigationController?.pushViewController(profileviewvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! FriendCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    
    
}


