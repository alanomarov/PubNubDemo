//
//  Channel.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation

/// Model holding channel messages and users.
final class Channel {

    /// The closure that will gets called every time the model is updated.
    var updateHandler: () -> Void = {}
    
    /// Channel id.
    var uuid: String
    
    /// Number of users online.
    var onlineUsersCount: Int = 0
    
    /// Keep number of unread messages until user opens this channel.
    var unreadMessages: Int = 0
    
    /// All loaded messages in channel.
    private var messages = [Message]()
    
    /// List of users in channel.
    private var users = [User]()

    // MARK: - Public methods
    func appendMessage(message: Message) {
        messages.append(message)
        
        // Notify subscribers about data change.
        updateHandler()
    }
    
    func getMessages() -> [Message] {
        return messages
    }

    func addUser(user: User) {
        if !users.contains(where: { $0.senderId == user.senderId}) {
            users.append(user)
            
            // Notify subscribers about data change.
            updateHandler()
        }
    }
    
    func removeUser(user: String) {
        users.removeAll(where: { $0.senderId == user })
        
        updateHandler()
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    init(uuid: String) {
        self.uuid = uuid
    }
    
}
