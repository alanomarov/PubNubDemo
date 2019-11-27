//
//  ChatDetailsViewController.swift
//  PubNumDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import UIKit

final class ChatDetailsViewController: UIViewController {

    private let cellHeight: CGFloat = 20
    private let reuseIdentifier = "UserTableViewCell"
    
    var channel: Channel?
    
    let chatManager = ChatManager.shared
    
    var chatDetailsView: ChatDetailsView {
        return view as! ChatDetailsView
    }
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: "ChatDetails", bundle: nil)
    }
    
    static func instantiate() -> ChatDetailsViewController {
        guard let controller =
            ChatDetailsViewController.storyboard.instantiateInitialViewController() as?
            ChatDetailsViewController else {
            fatalError("View controller can't be instantiated")
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe for model updates.
        channel?.updateHandler = reloadData
        
        reloadData()
    }
    
    private func reloadData() {
        chatDetailsView.tableView.reloadData()
    }
    
    private func setupTableView() {
        chatDetailsView.tableView.register(
            UINib(nibName: "UserTableViewCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        chatDetailsView.tableView.tableFooterView = UIView()
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ChatDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channel?.getUsers().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = chatDetailsView.tableView.dequeueReusableCell (
            withIdentifier: reuseIdentifier) as? UserTableViewCell {
            if let currentChannel = channel {
                let userid = currentChannel.getUsers()[indexPath.row].senderId
                cell.nameLabel.text = userid + (userid == chatManager.uuid ? " (you)" : "")
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
