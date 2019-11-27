//
//  ChatListener.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 20/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation
import PubNub

/// Protocol for the class listening on ChatClient events.
protocol ChatListener {
    
    /// Called when new message received.
    func messageReceived(message: Message)
    
    /// Called when connection status changed.
    func connectionStatusChanged(status: ConnectionStatus)
    
    /// Called when presence changed.
    func presenceChanged(event: PresenceEvent)
    
}
