//
//  CarsManager.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 18.09.2020.
//

import Foundation

class CarsManager {
    
    static var cars: [Car] = {
        guard let managedCars = CoreDataService.fetchObjects(ofType: ManagedCar.self) else { return [] }
        return managedCars.map { Car(managedCar: $0) }
    }()
    
    static var yearOfIssueValues: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(1885 ... currentYear).reversed()
    }
    
    static var bodyTypeValues: [BodyType] {
        return BodyType.allCases
    }
    
    static func addNewCar(manufacturer: String, model: String, yearOfIssue: Int, bodyType: BodyType) {
        let managedCar = ManagedCar(context: CoreDataService.context)
        managedCar.manufacturer = manufacturer
        managedCar.model = model
        managedCar.yearOfIssue = Int16(yearOfIssue)
        managedCar.bodyType = Int16(bodyType.rawValue)
        CoreDataService.saveContext()
        let car = Car(managedCar: managedCar)
        cars.append(car)
    }
    
}
