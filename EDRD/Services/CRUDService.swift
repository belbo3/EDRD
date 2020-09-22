//
//  CRUDService.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import CoreData
import PromiseKit

func crudService<Model: AnyModel>(dbService: CoreDataService = dbService()) -> CRUDService<Model> {
  return CRUDService(dbService: dbService)
}

enum CRUDServiceError: Error {
  case dbError(_ error: Error)
}

enum Result<Model: AnyModel> {
  case created(_ model: Model)
  case obtained(_ models: [Model])
  case updated(_ model: Model)
  case deleted(_ model: Model)
  case error(_ error: CRUDServiceError)
}

final class CRUDService<Model: AnyModel> {
  // MARK: - Properties
  
  typealias Observer = (Result<Model>) -> ()
  var observer: Observer?
  var dbService: CoreDataService
  
  // MARK: - Inits
  
  init(dbService: CoreDataService) {
    self.dbService = dbService
  }
}

extension CRUDService {
  // MARK: - Create methods
  
  func createEmptyModel(modelType: ModelType) -> Model {
    let managedContext = dbService.managedObjectContext
    guard let modelEntity = NSEntityDescription.entity(forEntityName: modelType.entity, in: managedContext) else { return nil! }
    let model = NSManagedObject(entity: modelEntity, insertInto: managedContext) as! Model
    return model
  }
  
  func createObserver(model: Model) {
    firstly {
      create(model: model)
    }.done {
      self.observer?(.created($0))
    }.catch {
      self.observer?(.error(.dbError($0)))
    }
  }
  
  func create(model: Model) -> Promise<Model> {
    return Promise { seal in
      do {
        try model.managedObjectContext?.save()
        seal.fulfill(model)
      } catch let error as NSError {
        seal.reject(error)
      }
    }
  }
  
  // MARK: - Read methods
  
  func readObserver(modelType: ModelType, predicates: [NSPredicate] = [], sortDescriptors: [NSSortDescriptor] = []) {
    firstly {
      read(modelType: modelType, predicates: predicates, sortDescriptors: sortDescriptors)
    }.done {
      self.observer?(.obtained($0))
    }.catch {
      self.observer?(.error(.dbError($0)))
    }
  }
  
  func read(modelType: ModelType, predicates: [NSPredicate] = [], sortDescriptors: [NSSortDescriptor] = []) -> Promise<[Model]> {
    return Promise { seal in
      let managedContext = dbService.managedObjectContext
      managedContext.performAndWait {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelType.entity)
        
        fetchRequest.fetchBatchSize = 20
        if !predicates.isEmpty {
          fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        if !sortDescriptors.isEmpty {
          fetchRequest.sortDescriptors = sortDescriptors
        }
        
        do {
          let result = try managedContext.fetch(fetchRequest)
          seal.fulfill(result as! [Model])
        } catch {
          seal.reject(error)
        }
      }
    }
  }
  
  // MARK: - Update methods
  
  func updateObserver(model: Model) {
    firstly {
      update(model: model)
    }.done {
      self.observer?(.updated($0))
    }.catch {
      self.observer?(.error(.dbError($0)))
    }
  }
  
  func update(model: Model) -> Promise<Model> {
    return Promise { seal in
      do {
        try model.managedObjectContext?.save()
        seal.fulfill(model)
      } catch let error as NSError {
        seal.reject(error)
      }
    }
  }
  
  // MARK: - Delete methods
  
  func deleteObserver(model: Model) {
    firstly {
      delete(model: model)
    }.done {
      self.observer?(.deleted($0))
    }.catch {
      self.observer?(.error(.dbError($0)))
    }
  }
  
  func delete(model: Model) -> Promise<Model> {
    return Promise { seal in
      model.managedObjectContext?.delete(model)
      do {
        try model.managedObjectContext?.save()
        seal.fulfill(model)
      } catch let error as NSError {
        seal.reject(error)
      }
    }
  }
}
