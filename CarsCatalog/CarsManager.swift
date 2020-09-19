//
//  CarsManager.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 18.09.2020.
//

import Foundation

final class CarsManager {
    
    static let shared = CarsManager()
    
    private var isDefaultCarsCreated: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IsDefaultCarsCreated")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsDefaultCarsCreated")
        }
    }
    
    private(set) lazy var cars: [Car] = {
        createDefaultCarsIfNeeded()
        guard let managedCars = CoreDataService.fetchObjects(ofType: ManagedCar.self) else { return [] }
        return managedCars.map { Car(managedCar: $0) }
    }()
    
    var yearOfIssueValues: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(1885 ... currentYear).reversed()
    }
    
    var bodyTypeValues: [BodyType] {
        return BodyType.allCases
    }
    
    private func createDefaultCarsIfNeeded() {
        if isDefaultCarsCreated { return }
        isDefaultCarsCreated = true
        let car1 = ManagedCar(context: CoreDataService.context)
        car1.manufacturer = "Mitsubishi"
        car1.model = "Outlander"
        car1.yearOfIssue = 2012
        car1.bodyType = Int16(BodyType.sportUtilityVehicle.rawValue)
        let car2 = ManagedCar(context: CoreDataService.context)
        car2.manufacturer = "Nissan"
        car2.model = "Tiida"
        car2.yearOfIssue = 2009
        car2.bodyType = Int16(BodyType.hatchback.rawValue)
        let car3 = ManagedCar(context: CoreDataService.context)
        car3.manufacturer = "Toyota"
        car3.model = "Vista"
        car3.yearOfIssue = 1994
        car3.bodyType = Int16(BodyType.sedan.rawValue)
        CoreDataService.saveContext()
    }
    
    func addNewCar(manufacturer: String, model: String, yearOfIssue: Int, bodyType: BodyType) {
        let managedCar = ManagedCar(context: CoreDataService.context)
        managedCar.manufacturer = manufacturer
        managedCar.model = model
        managedCar.yearOfIssue = Int16(yearOfIssue)
        managedCar.bodyType = Int16(bodyType.rawValue)
        CoreDataService.saveContext()
        let car = Car(managedCar: managedCar)
        cars.append(car)
    }
    
    func deleteCar(atIndex index: Int) {
        let managedCar = cars.remove(at: index).managedCar
        CoreDataService.context.delete(managedCar)
        CoreDataService.saveContext()
    }
    
    func updateCar(atIndex index: Int, manufacturer: String, model: String, yearOfIssue: Int, bodyType: BodyType) {
        let managedCar = cars[index].managedCar
        managedCar.manufacturer = manufacturer
        managedCar.model = model
        managedCar.yearOfIssue = Int16(yearOfIssue)
        managedCar.bodyType = Int16(bodyType.rawValue)
        CoreDataService.saveContext()
    }
    
}
