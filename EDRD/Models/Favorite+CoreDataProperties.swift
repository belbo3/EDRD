//
//  Favorite+CoreDataProperties.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 22.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//
//

import Foundation
import CoreData

extension Favorite {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
    return NSFetchRequest<Favorite>(entityName: "Favorite")
  }
  
  @NSManaged public var comment: String?
  @NSManaged public var firstName: String?
  @NSManaged public var lastName: String?
  @NSManaged public var linkPDF: String?
  @NSManaged public var placeOfWork: String?
  @NSManaged public var position: String?
  @NSManaged public var id: String
}
