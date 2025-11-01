//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//

import Foundation
struct Contact: Codable, Identifiable
{
    /// for contact id
    var id = UUID()
    /// for contact name
    var name: String
    // for contact phone number
    var phoneNumber: String
    /// Optional profile image stored as binary data
    var imageData: Data?
    
    /// Returns a UIImage if image data is available
    var profileImage: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}
