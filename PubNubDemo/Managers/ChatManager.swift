//
//  ChatManager.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 18/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation
import PubNub

/// Put your publish and subscribe keys here.
fileprivate let PUBNUB_PUBLISH_KEY = ""
fileprivate let PUBNUB_SUBSCRIBE_KEY = ""

enum RequestResult {
    case success(Any?)
    case failure(String?)
}

/// Request handler
///
/// - String: Error string
typealias RequestHandler = (RequestResult) -> ()

final class ChatManager {
    
    static let shared = ChatManager()
        
    private let chatClient = ChatClient()
    
    var updateHandler: () -> Void = {}
    
    /// Channels map by uuid.
    var channels = [Channel]()
    
    // TODO: keep only contacts
    /// Keep list of users separately to update their status.
    /// Users map by uuid.
    var users: [String : User]?
    
    /// Channel that will be used to send a message.
    var activeChannel: String?
    
    var uuid: String?
    
    private init() {
    }
    
    func configure(config: Config) {
        chatClient.configure(publishKey: PUBNUB_PUBLISH_KEY,
                             subscribeKey: PUBNUB_SUBSCRIBE_KEY,
                             uuid: config.uuid,
                             authKey: config.authKey,
                             listener: self)
        
        self.uuid = config.uuid
        
        loadChannels(uuids: config.channels);
    }

    private func loadChannels(uuids: [String]) {
        // Subscribe for channels and pull history and users.
        for channel in uuids {
            channels.append(Channel(uuid: channel))
            
            joinChannel(channel: channel)
            fetchHistory(channel: channel)
            fetchUsers(channel: channel)
        }
    }
    
    func joinChannel(channel: String) {
        chatClient.subscribeToChannel(channel: channel)
    }
    
    func leaveChannel(channel: String) {
        chatClient.unsubscribeFromChannel(channel: channel)
    }
    
    func sendMessage(channel: String, text: String) {
        guard let uuid = self.uuid else {
            fatalError("Chat client is not configured")
        }
        
        let message = Message(uuid: UUID().uuidString,
                              text: text,
                              sentAt: Date(),
                              senderId: uuid,
                              channelId: channel)
        chatClient.sendMessage(channel: channel, message: message)
    }
    
    func fetchHistory(channel: String) {
        guard let channelObj = channels.first(where: { $0.uuid == channel }) else {
            // TODO: create new channel?
            return
        }
        
        chatClient.fetchHistory(channel: channel) { result in
            switch result {
            case .success(let messages):
                for message in messages as! [Message] {
                    channelObj.appendMessage(message: message)
                }
            case .failure(let error):
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func fetchUsers(channel: String) {
        guard let channelObj = channels.first(where: { $0.uuid == channel }) else {
            // TODO: create new channel?
            //handler(false)
            return
        }
        
        chatClient.fetchUsers(channel: channel) { result in
            switch result {
                case .success(let users):
                    
                    if let uuids = users as? [String] {
                    
                        channelObj.onlineUsersCount = uuids.count
                        
                        for user in uuids {
                            channelObj.addUser(user: User(senderId: user, displayName: ""))
                        }
                    }
                case .failure(let error):
                    print("Error: \(String(describing: error))")
            }
        }
    }
}

extension ChatManager: ChatListener {
    func messageReceived(message: Message) {
        // Find channel by id.
        guard let channel = channels.first(where: { $0.uuid == message.channelId }) else {
            // TODO: create new channel?
            return
        }
        
        channel.appendMessage(message: message)
        if !(channel.uuid == activeChannel) {
            channel.unreadMessages += 1
        }
        
        updateHandler();
    }
    
    func connectionStatusChanged(status: ConnectionStatus) {

    }
    
    func presenceChanged(event: PresenceEvent) {
        // Find channel by id.
        guard let channel = channels.first(where: { $0.uuid == event.channel }) else {
            // TODO: create new channel?
            return
        }
        
        channel.onlineUsersCount = event.occupancy

        // Add and remove users which changed presence.
        for user in event.join {
            channel.addUser(user: User(senderId: user, displayName: ""))
        }
        
        for user in event.leave {
            channel.removeUser(user: user)
        }
        
        updateHandler();
    }
}
