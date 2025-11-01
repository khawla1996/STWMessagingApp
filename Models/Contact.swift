//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//

import Foundation
struct Contact: Codable, Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
}
