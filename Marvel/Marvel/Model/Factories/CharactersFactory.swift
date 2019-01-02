//
//  CharactersFactory.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 25/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class to create the instances of Character
class CharactersFactory {
    
     /**
     This method gets a Character from a NSManagedObject
     
     - parameter object: Register we use to create the character
     
     - returns: Character with the data of the register
     */
    static func characterWithManagedObject(_ object:NSManagedObject)->Character {
        let character = Character()
        character.id = Int64((object.value(forKey: "id") as! Int))
        character.name = (object.value(forKey: "name") as? String)!
        character.descriptionCharacter = (object.value(forKey: "descriptionCharacter") as? String)!
        character.modified = (object.value(forKey: "modified") as? Date)!
        character.resourceURI = (object.value(forKey: "resourceURI") as? String)!
        character.thumbnail = (object.value(forKey: "thumbnail") as? String)!
        return character
    }
    
     /**
     This method gets an array of Character from an array of NSManagedObject
     
     - parameter objects: array of registers to get the characters
    
     - returns: list of characters
     */
    static func getCharactersWithObjects(_ objects:[NSManagedObject]) -> [Character] {
        var characters:[Character] = []
        
        for object in objects {
            let newCharacter = characterWithManagedObject(object as NSManagedObject)
            characters.append(newCharacter)
        }
        
        return characters
    }
    
     /**
     This method gets an NSManagedObject from a Character
     
     - parameter character: Character to get the register
     
     - returns: Register to store with the data of the character
     */
    static func managedObjectWithCharacter(_ character:Character)->NSManagedObject {
        
        //We need the managedContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //We get the entity for type Character
        let entity =  NSEntityDescription.entity(forEntityName: "Character", in:managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(NSNumber(value: character.id as Int64), forKey: "id")
        object.setValue(character.name, forKey: "name")
        object.setValue(character.descriptionCharacter, forKey: "descriptionCharacter")
        object.setValue(character.modified, forKey: "modified")
        object.setValue(character.resourceURI, forKey: "resourceURI")
        object.setValue(character.thumbnail, forKey: "thumbnail")
        
        return object
        
    }
    
     /**
     This method an array of Characters from a dictionary (the one that comes from the Marvel's API)
     
     - parameter objects: list of items that we obtain from the call to the Marvel API
     
     - returns: array of characters
     */
    static func getCharactersWithArrayDictionaries(_ objects:[[String: Any]])->[Character] {
        var characters = [Character]()
        
        for currentObject in objects {
            let newCharacter = Character()
            
            newCharacter.id = Int64(currentObject["id"] as! Int)
            newCharacter.name = (currentObject["name"] as? String)!
            newCharacter.descriptionCharacter = (currentObject["description"] as? String)!
            newCharacter.modified = Constants.convertDateFormater((currentObject["modified"] as? String)!, format: "yyyy-MM-dd'T'HH:mm:ss-SSSS")
            newCharacter.resourceURI = (currentObject["resourceURI"] as? String)!
            let path = (currentObject["thumbnail"] as! [String : String])["path"]! as String
            let extensionImage = (currentObject["thumbnail"] as! [String : String])["extension"]! as String
            newCharacter.thumbnail = "\(path).\(extensionImage)"
            DownloadManager.downloadImage(newCharacter)
            
            characters.append(newCharacter)
        }
        
        return characters
    }
    
}
