//
//  Car.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 19.09.2020.
//

import Foundation

struct Car {
    
    let managedCar: ManagedCar
    
    var manufacturer: String {
        return managedCar.manufacturer ?? ""
    }
    
    var model: String {
        return managedCar.model ?? ""
    }
    
    var yearOfIssue: Int {
        return Int(managedCar.yearOfIssue)
    }
    
    var bodyType: BodyType {
        return BodyType(rawValue: Int(managedCar.bodyType)) ?? .sedan
    }
    
}
