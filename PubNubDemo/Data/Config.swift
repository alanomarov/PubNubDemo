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

fileprivate let user1Channels = ["chat01", "chat03"]
fileprivate let user2Channels = ["chat01"]
fileprivate let user3Channels = ["chat03"]
fileprivate let defaultChannels = ["teamchat"]

fileprivate let user1AuthKey = "user1auth"
fileprivate let user2AuthKey = "user2auth"
fileprivate let user3AuthKey = "user3auth"
fileprivate let defaultAuthKey = "teamauth"

/// Class storing chat client configuration.
struct Config {
    
    /// List of channels to connect.
    var channels: [String]
    
    /// Auth key used for user auth on PubNub service.
    var authKey: String
    
    /// User uuid.
    /// NOTE: it will be used as display name also as we do not store users on server.
    var uuid: String
    
    private init(uuid: String, channels: [String], authKey: String) {
        self.uuid = uuid
        self.channels = channels
        self.authKey = authKey
    }

    /// Get default config by username.
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

