import Foundation
import CoreLocation
//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//

// Message+CoreDataProperties.swift
import Foundation
import CoreData

extension Message {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: UUID
    @NSManaged public var text: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var timestamp: Date
    @NSManaged public var isSent: Bool
    @NSManaged public var conversation: Conversation?
}
