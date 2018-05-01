//
//  Meal.swift
//  FoodTracker
//
//  Created by Zhihang Zhang on 2018-04-26.
//  Copyright © 2018 Zhihang Zhang. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {

    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archving Paths
    static let  DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    //The static keyword indicates that these
    //constants belong to the structure itself, not to instances of the structure.
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name) // property variable , key string
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    /*
     The required modifier means this initializer must be implemented on every subclass, if
     the subclass defines its own initializers. The convenience modifier means that this is
     a secondary initializer, and that it must call a designated initializer from the same class.
     The question mark (?) means that this is a failable initializer that might return nil.
     */
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
        
    }
}
