//
//  NSObject.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 19.09.2020.
//

import Foundation

extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
}
