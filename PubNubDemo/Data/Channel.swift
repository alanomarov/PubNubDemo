//
//  Channel.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation

final class Channel {

    // The closure that will gets called every time the
    // view model was updated
    var updateHandler: () -> Void = {}
    
    var uuid: String
    
    var onlineUsersCount: Int = 0
    
    /// All loaded messages in channel.
    private var messages = [Message]()
    
    func appendMessage(message: Message) {
        messages.append(message)
        
        // Notify subscribers about data change.
        updateHandler()
    }
    
    func getMessages() -> [Message] {
        return messages
    }

    /// List of users in channel.
    private var users = [User]()
    
    func addUser(user: User) {
        if !users.contains(where: { $0.senderId == user.senderId}) {
            users.append(user)
            
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
    
    /// Keep number of unread messages until user opens this channel.
    var unreadMessages: Int = 0
    
    init(uuid: String) {
        self.uuid = uuid
    }
}
