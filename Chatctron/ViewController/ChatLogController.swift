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
    var messages:[Message]  = [
        Message(text: "Hello Harry", isIncoming: true, date: Date().addingTimeInterval(-60*60*24*22)),
        Message(text: "Do you like my new song?", isIncoming: true, date: Date().addingTimeInterval(-60*60*24*2)),
        Message(text: "yes!", isIncoming: true, date: Date().addingTimeInterval(-60*60)),
        Message(text: "It sounds great!", isIncoming: false, date: Date()),
        Message(text: "I hope you enjoy it!", isIncoming: true, date: Date().addingTimeInterval(60)),
        Message(text: "I will see you at my concert, have a nice day!", isIncoming: true, date: Date().addingTimeInterval(60*2)),
    ]
    
    
    var chatMessage = [[Message]]()
    func groupMessage() {
        let cal = Calendar.current
        let dictMessage = Dictionary(grouping: messages, by: {
            (element) in
            return cal.date(from: cal.dateComponents([.year, .month, .day, .hour, .minute], from: element.date))
            
        })
        let sortKeys = dictMessage.keys.sorted(by: {
            $0?.compare($1 ?? Date()) ==  .orderedAscending
        })
        sortKeys.forEach({
            (key) in
            chatMessage.append(dictMessage[key] ?? [])
        })
    }
    var tableView: UITableView  = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = .white
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
        return chatMessage.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessage[section].count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Date.convertDateToString(date:chatMessage[section].first?.date ?? Date())
        label.font = UIFont.boldSystemFont(ofSize:16)
        label.backgroundColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = chatMessage[indexPath.section][indexPath.row]
        if message.isIncoming {
            let cell = tableView.dequeueReusableCell(withIdentifier: incomingid, for: indexPath) as! IncomingMessageCell
            
            cell.messageLabel.text = message.text
            cell.profileimageView.image = profileImage
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MessageCell
            
            cell.messageLabel.text = message.text
            return cell
        }
        
        
    }
    
    let incomingid = "messageCell"
    let id = "id"
    
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
        tableView.register(IncomingMessageCell.self, forCellReuseIdentifier: incomingid)
        tableView.register(MessageCell.self, forCellReuseIdentifier: id)
        groupMessage()
        
    }
    
}


extension Date {
    static func convertDateToString(date:Date)->String{
        var text:String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let elapseTimeInSeconds = Date().timeIntervalSince(date)
        let secondsInDay: TimeInterval = 60*60*24
        if elapseTimeInSeconds > 7*secondsInDay {
            dateFormatter.dateFormat = "MM/dd/yy"
        }else if elapseTimeInSeconds > secondsInDay {
            
            dateFormatter.dateFormat = "EEE"
        }
        text = dateFormatter.string(from: date)
        return text
    }
}
