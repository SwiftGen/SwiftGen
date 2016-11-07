import Foundation
import CoreData

public func createContext() -> NSManagedObjectContext {
   let modelUrl = NSBundle.mainBundle().URLForResource("User", withExtension: "momd")!
   let model = NSManagedObjectModel(contentsOfURL: modelUrl)!
   let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
   try! coordinator.addPersistentStoreWithType(NSInMemoryStoreType,
                                               configuration: nil,
                                               URL: nil,
                                               options: nil)
   let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
   context.persistentStoreCoordinator = coordinator
   return context
}
