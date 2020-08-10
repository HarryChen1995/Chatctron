//
//  ProfileViewController.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/5/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class ChatLogController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var firstName: String?
    var lastName: String?
    var userID: String?
    var email: String?
    var profileImage:UIImage?
    var message:[String]  = ["adsasdasdfjeiuwofjioewjfiowejfoiwejfiowejfiowejfoiwejfoiwejfiowejfasdasdasdad", "asdasdasdasdasdadadadasdadasdafjhuwhfiuhwiufhewiufhiuwefhiuwehfiuwehfiuwefdads", "hello"]
    var tableView: UITableView  = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
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
        
        setupTableView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + message.count
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
        return 200
    }
    return tableView.rowHeight

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageID, for: indexPath) as! ProfileMessageCell
            cell.profileImageView.image = profileImage
            cell.nameLabel.text = firstName! + " "  + lastName!
            cell.emailLabel.text = ": " + email!
            return cell
        }
        else{
             let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MessageCell
            cell.messageLabel.text = message[indexPath.row - 1]
            cell.profileimageView.image = profileImage
            return cell
        }
        
    }
    
    
    let id = "messageCell"
    let messageID = "message"
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(MessageCell.self, forCellReuseIdentifier: id)
        tableView.register(ProfileMessageCell.self, forCellReuseIdentifier: messageID)

    }
    
}
