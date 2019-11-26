//
//  ChatListTableViewCell.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 19/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import UIKit

final class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var onlineUsers: UILabel!
    @IBOutlet var unreadMessages: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
