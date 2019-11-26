//
//  Utils.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 20/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation
import PubNub

/// Helper class.
final class Utils {
    static func timetokenToDate(timetoken: Timetoken) -> Date {
        let unixTimestamp = Double(timetoken / 10000000)
        let gmtDate = Date.init(timeIntervalSince1970: unixTimestamp)
        
        return gmtDate
    }
    
    static func messageFromPubNub(pubMessage: AnyJSON, channel: String, timetoken: Timetoken) -> Message? {
        if let json = pubMessage.dictionaryOptional {
            if let text = json["text"] as? String,
                let senderid = json["senderId"] as? String,
                let messageid = json["uuid"] as? String {
                
                    let message = Message(uuid: messageid,
                                          text: text,
                                          sentAt: Utils.timetokenToDate(timetoken: timetoken),
                                          senderId: senderid,
                                          channelId: channel)
                
                return message
            }
        }

        return nil
    }
    
    static func parsePubNubHistory(payload: MessageHistoryChannelsPayload, channel: String) -> [Message] {
        var messages = [Message]()
        
        for (id, history) in payload {
            if id == channel {
                for pubMessage in history.messages {
                    
                    // Parse message.
                    if let message = Utils.messageFromPubNub(pubMessage: pubMessage.message, channel: id, timetoken: pubMessage.timetoken) {
                        messages.append(message)
                    }
                }
            }
        }
        
        return messages
    }
    
    static func parsePubNubUsers(payload: HereNowPayload, channel: String) -> [String] {
        var users = [String]()
        
        for (id, pubChannel) in payload.channels {
            if id == channel {
                for pubUser in pubChannel.uuids {
                    users.append(pubUser.uuid)
                }
            }
        }
        
        return users
    }
}
