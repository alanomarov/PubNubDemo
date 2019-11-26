//
//  Message.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation
import MessageKit
import PubNub

struct Message: JSONCodable {
    var uuid: String
    var text: String
    var sentAt: Date
    var senderId: String
    var channelId: String
}

extension Message: MessageKit.MessageType {
    var sentDate: Date {
        return sentAt
    }
    
    var messageId: String {
        return uuid
    }

    var sender: SenderType {
        // Alan: we use sender id as display name as we are not storing users on server.
        return User(senderId: senderId, displayName: senderId)
    }

    var kind: MessageKind {
        return .text(self.text)
    }
}
