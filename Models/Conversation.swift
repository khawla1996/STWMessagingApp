
//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//
import Foundation

/// Represents a conversation between the user and a contact.
struct Conversation: Identifiable, Codable {
    /// Unique identifier for the conversation
    var id = UUID()
    
    /// The contact name or phone number
    var contactName: String
    
    /// List of messages exchanged in the conversation
    var messages: [Message]
    
    /// Date of the last message sent or received
    var lastUpdated: Date {
        messages.last?.timestamp ?? Date()
    }
    
    // MARK: - Computed Properties
    
    /// Returns the last message text (or placeholder if empty)
    var lastMessagePreview: String {
        if let last = messages.last {
            switch last.type {
            case .text:
                return last.text ?? ""
            case .image:
                return "Image"
            case .location:
                return "Location shared"
            }
        }
        return "No messages yet"
    }
}

