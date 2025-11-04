
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "STWMessagingApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save failed: \(error)")
            }
        }
    }
}
