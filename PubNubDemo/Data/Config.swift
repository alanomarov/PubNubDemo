//
//  Config.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 26/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation

fileprivate let defaultUser1 = "user1"
fileprivate let defaultUser2 = "user2"
fileprivate let defaultUser3 = "user3"

fileprivate let user1Channels = ["chat001", "chat002"]
fileprivate let user2Channels = ["chat001"]
fileprivate let user3Channels = ["chat002"]
fileprivate let defaultChannels = ["teamChat"]

fileprivate let user1AuthKey = "user1auth"
fileprivate let user2AuthKey = "user2auth"
fileprivate let user3AuthKey = "user3auth"
fileprivate let defaultAuthKey = "teamauth"

/// Class storing chat client configuration.
struct Config {
    var channels: [String]
    var authKey: String
    var uuid: String
    
    private init(uuid: String, channels: [String], authKey: String) {
        self.uuid = uuid
        self.channels = channels
        self.authKey = authKey
    }

    /// Storing default configs for the demo.
    static func getConfigForUser(user: String) -> Config {
        if user == defaultUser1 {
            return Config(uuid: user, channels: user1Channels, authKey: user1AuthKey)
        }
        else if user == defaultUser2 {
            return Config(uuid: user, channels: user2Channels, authKey: user2AuthKey)
        }
        else if user == defaultUser3 {
            return Config(uuid: user, channels: user3Channels, authKey: user3AuthKey)
        }
        
        return Config(uuid: user, channels: defaultChannels, authKey: defaultAuthKey)
    }
}

