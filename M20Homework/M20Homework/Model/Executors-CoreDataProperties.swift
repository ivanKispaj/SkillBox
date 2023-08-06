//
//  Executors-CoreDataProperties.swift
//  M20Homework
//
//  Created by Ivan Konishchev on 06.08.2023.
//

import Foundation
import CoreData

extension Executors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Executors> {
        return NSFetchRequest<Executors>(entityName: "Executors")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var date: Date?
    @NSManaged public var country: String?

}

extension Executors : Identifiable {

}
