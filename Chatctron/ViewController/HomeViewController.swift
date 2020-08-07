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
    
    let loadingView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func deleteCurrentUser(){
        let progressWindow = ProgressWindow()
        progressWindow.showProgress()
        let user = Auth.auth().currentUser
        let userId = user?.uid
        
        
        
        let db = Firestore.firestore()
        db.collection("users").document("\(userId!)").delete() { err in
            if let err = err {
                print(err)
            } else {
            }
            
            user?.delete { error in
                if let err = error {
                    let attributedString = NSAttributedString(string: "Delete Your Accouunt Failed!", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.red
                    ])
                    let alertController = UIAlertController(title: "" , message:                err.localizedDescription, preferredStyle: .alert)
                    alertController.setValue(attributedString, forKey: "attributedTitle")
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                    progressWindow.dissmisProgress()
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    
                    
                    // delete profile picture
                    let desertRef = Storage.storage().reference().child("image/\(userId!).png")
                    desertRef.delete { error in
                        if let err = error {
                            
                            let attributedString = NSAttributedString(string: "Delete Your Profile Image Failed!", attributes: [
                                NSAttributedString.Key.foregroundColor : UIColor.red
                            ])
                            let alertController = UIAlertController(title: "" , message:                err.localizedDescription, preferredStyle: .alert)
                            alertController.setValue(attributedString, forKey: "attributedTitle")
                            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                            progressWindow.dissmisProgress()
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            
                            
                            let alertController = UIAlertController(title: "Deletion Success" , message: "Your acount has been successfully deleted, sorry to see you go! ", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style:.default, handler:  { (action) in
                                let loginVC = LoginViewController()
                                self.navigationController?.pushViewController(loginVC, animated: true)
                            }))
                            progressWindow.dissmisProgress()
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                        
                    }
                }
                
            }
        }
    }
    
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
            self.tableView.isUserInteractionEnabled = true
            self.loadingView.isHidden = true
        }else{
            let db = Firestore.firestore()
            db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let user = User(userID: document.documentID, firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, email: data["email"] as! String)
                        self.fetchUserProfileImage(userID: user.userID,completion:  {
                            (image) in
                            user.profileImage = image
                        }
                        )
                        if document.documentID != Auth.auth().currentUser?.uid  {
                            
                            self.users.append(user)
                        }
                        else{
                            self.currentUser = user
                            self.navigationItem.leftBarButtonItem?.isEnabled = true
                            self.sideMenu.currentUser = self.currentUser
                            self.sideMenu.delegate = self
                            self.sideMenu.menu.collectionView.reloadData()
                        }
                    }
                    usersCache.setObject(self.users as NSArray, forKey: "users" as NSString)
                    self.tableView.isUserInteractionEnabled = true
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                    
                    
                    
                }
            }
            
        }
    }
    
    
    
    let ID = "Friend"
    var users: [User] = []
    var userID:String?
    var currentUser:User?
    
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
    
    func logout(){
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }catch{
            print(error)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.setup()
        view.backgroundColor = .white
        navigationItem.title = "Friends"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(displaySideMenu))
        navigationItem.leftBarButtonItem?.isEnabled = false
        tableView.tableFooterView = UIView()
        tableView.register(FriendCell.self, forCellReuseIdentifier: ID)
        setupLoadingView()
        tableView.isUserInteractionEnabled = false
        fetchUsers()
        
        
    }
    
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.safeAreaLayoutGuide.centerYAnchor).isActive = true
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
        let chatlogvc =  ChatLogController()
        chatlogvc.firstName = user.firstName
        chatlogvc.lastName = user.lastName
        chatlogvc.userID  = user.userID
        chatlogvc.email = user.email
        chatlogvc.profileImage = user.profileImage
        navigationController?.pushViewController( chatlogvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! FriendCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    
    
}


