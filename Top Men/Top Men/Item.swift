//
//  Item.swift
//  Top Men
//
//  Created by Casey Marshall on 3/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
