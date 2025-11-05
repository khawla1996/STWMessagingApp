
//
//  Conversation+CoreDataProperties.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//

import Foundation
import CoreData

extension Conversation {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var id: UUID
    @NSManaged public var contactName: String
    @NSManaged public var messages: NSSet?
}

extension Conversation {
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)
}
