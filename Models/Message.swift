import Foundation
import CoreLocation
//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//

/// Represents the type of message exchanged in a conversation.
enum MessageType: String, Codable {
    case text
    case image
    case location
}

/// Represents a single message exchanged between two users.
struct Message: Identifiable, Codable {
    /// Unique message ID
    var id = UUID()
    
    /// Sender name or ID
    var sender: String
    
    /// Optional text content
    var text: String?
    
    /// Optional image data
    var imageData: Data?
    
    /// Optional location coordinates
    var latitude: Double?
    var longitude: Double?
    
    /// Date and time the message was sent
    var timestamp: Date
    
    /// Type of message (text, image, or location)
    var type: MessageType
}
