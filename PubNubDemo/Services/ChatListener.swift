//
//  ChatListener.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 20/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation
import PubNub

protocol ChatListener {
    func messageReceived(message: Message)
    func connectionStatusChanged(status: ConnectionStatus)
    func presenceChanged(event: PresenceEvent)
}
