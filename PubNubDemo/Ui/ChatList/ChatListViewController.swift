//
//  ChatListViewController.swift
//  PubNumDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import UIKit

let savedUUIDString = "UUID"

final class ChatListViewController: UIViewController {

    let chatManager = ChatManager.shared

    private let cellHeight: CGFloat = 70
    private let reuseIdentifier = "ChatListTableViewCell"
    
    var chatListView: ChatListView {
        return view as! ChatListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        // If uuid is not saved on device offer user to enter new one.
        if let uuid = UserDefaults.standard.string(forKey: savedUUIDString) {
            chatManager.configure(config: Config.getConfigForUser(user: uuid))
        }
        else {
            let welcomeViewController = WelcomeViewController.instantiate()
            welcomeViewController.modalPresentationStyle = .fullScreen
            self.present(welcomeViewController, animated: true)
        }
        
        chatManager.updateHandler = chatListView.chatListTable.reloadData
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatListView.chatListTable.reloadData()
    }
    
    private func setupTableView() {
        chatListView.chatListTable.register(
            UINib(nibName: "ChatListTableViewCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        chatListView.chatListTable.tableFooterView = UIView()
    }
}

// UITableViewDelegate, UITableViewDataSource
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatManager.channels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = chatListView.chatListTable.cellForRow(at: indexPath) as? ChatListTableViewCell {
            // Open chat with uuid.
            chatManager.activeChannel = chatManager.channels[indexPath.row].uuid
            let chatViewController = ChatViewController.instantiate(channel: chatManager.channels[indexPath.row])
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = chatListView.chatListTable.dequeueReusableCell(
            withIdentifier: reuseIdentifier) as? ChatListTableViewCell {
            cell.nameLabel.text = chatManager.channels[indexPath.row].uuid
            let userCount = chatManager.channels[indexPath.row].onlineUsersCount
            let unreadMessages = chatManager.channels[indexPath.row].unreadMessages
            cell.onlineUsers.text =  "\(userCount) users online"
            cell.unreadMessages.text = unreadMessages > 0 ? "\(unreadMessages) new message(s)" : ""
            
            return cell
        }
        return UITableViewCell()
    }
}
