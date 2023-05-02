//
//  BookMarked+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 01/05/23.
//
//

import Foundation
import CoreData


extension BookMarked {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMarked> {
        return NSFetchRequest<BookMarked>(entityName: "BookMarked")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var date: Date?
    @NSManaged public var type: String?
    @NSManaged public var image: String?
    @NSManaged public var high: Double
    @NSManaged public var low: Double
    @NSManaged public var temperature: Double
    @NSManaged public var humidity: Double
    @NSManaged public var pressure: Double
    @NSManaged public var rainChance: Double
    @NSManaged public var wind: Double
}

extension BookMarked : Identifiable {

}
