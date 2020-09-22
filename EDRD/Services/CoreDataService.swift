//
//  CoreDataService.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import CoreData

func dbService() -> CoreDataService {
  return CoreDataService.shared
}

final class CoreDataService {
  static let shared = CoreDataService()
  
  lazy var applicationDocumentsDirectory: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle(identifier: "WolfDevelopment.EDRD")!.url(forResource: "EDRD", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent("EDRD.sqlite")
    
    let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
    } catch {
      print(error)
    }
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    if Thread.isMainThread {
      managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    } else {
      managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
}
