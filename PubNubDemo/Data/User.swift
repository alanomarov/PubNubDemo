//
//  User.swift
//  PubNubDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import Foundation
import MessageKit

/// Struct holding a user information.
struct User: SenderType {
    
    var senderId: String
    var displayName: String

    var firstName: String?
    var lastName: String?
    
}
