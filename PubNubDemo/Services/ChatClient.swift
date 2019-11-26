//
//  ChatClient.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 18/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import PubNub

import Foundation
import MessageKit

final class ChatClient {
    var pubnub: PubNub?
    var listener: ChatListener?
    
    let subscriptionListener = SubscriptionListener()
    
    func sendMessage(channel: String, message: Message) {
        pubnub?.publish(channel: channel, message: message) { result in
            switch result {
              case let .success(response):
                print("Successful Response: \(response)")
              case let .failure(error):
                print("Failed Response: \(error.localizedDescription)")
            }
        }
    }

    func fetchHistory(channel: String, handler: @escaping RequestHandler) {
        self.pubnub?.fetchMessageHistory(for: [channel], completion: { result in
            switch result {
                case let .success(response):
                    //print("Successful History Fetch Response: \(response)")
                    
                    let messages = Utils.parsePubNubHistory(payload: response, channel: channel)
                    handler(.success(messages))
                
                case let .failure(error):
                    handler(.failure(error.localizedDescription))
            }
        })
    }
    
    func fetchUsers(channel: String, handler: @escaping RequestHandler) {
        self.pubnub?.hereNow(on: [channel], completion: { result in
            switch result {
                case let .success(response):
                    //print("Successful Users Fetch Response: \(response)")
                    let users = Utils.parsePubNubUsers(payload: response, channel: channel)
                    handler(.success(users))
                case let .failure(error):
                    handler(.failure(error.localizedDescription))
            }
        })
    }
    
    func subscribeToChannel(channel: String) {
        pubnub?.subscribe(to: [channel], withPresence: true)
    }
    
    func unsubscribeFromChannel(channel: String) {
        pubnub?.unsubscribe(from: [channel])
    }
    
    func configure(publishKey: String, subscribeKey: String, uuid: String, authKey: String, listener: ChatListener?) {
        self.listener = listener

        // Initialize pubnub object.
        var configuration = PubNubConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        configuration.uuid = uuid
        configuration.authKey = authKey
        
        pubnub = PubNub(configuration: configuration)
        
        // Subscribe for notifications.
        subscriptionListener.didReceiveSubscription = { event in
            switch event {
                case .messageReceived(let event):
                    if let message = Utils.messageFromPubNub(pubMessage: event.payload, channel: event.channel, timetoken: event.timetoken) {
                        listener?.messageReceived(message: message)
                    }
                case .connectionStatusChanged(let status):
                    //print("Status Received: \(status)")
                    listener?.connectionStatusChanged(status: status)
                case .presenceChanged(let presence):
                    //print("Presence Received: \(presence)")
                    listener?.presenceChanged(event: presence)
                case .subscribeError(let error):
                    print("Subscription Error \(error)")
                default:
                    break
            }
        }
        
        pubnub?.add(subscriptionListener)
    }
}
