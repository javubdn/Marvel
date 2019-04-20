//
//  Constants.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 21/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: - Type data
    
    enum TypeData : Int {
        case characters, comics, creators, events, series, stories
        
        func getDescription() -> String {
            switch self {
            case .characters:
                return "characters"
            case .comics:
                return "comics"
            case .creators:
                return "creators"
            case .events:
                return "events"
            case .series:
                return "series"
            case .stories:
                return "stories"
            }
        }
		
		func getTable() -> String {
			switch self {
			case .characters:
				return "Character"
			case .comics:
				return "Comic"
			case .creators:
				return "Creator"
			case .events:
				return "Event"
			case .series:
				return "Serie"
			case .stories:
				return "Story"
			}
		}
        
        func getSegue() -> String {
            return "showDetail"
        }
		
        static func getValue(_ value: Int) -> TypeData {
            switch value {
            case 0:
                return .characters
            case 1:
                return .comics
            case 2:
                return .creators
            case 3:
                return .events
            case 4:
                return .series
            case 5:
                return .stories
            default:
                return .characters //Imposible case
            }
        }
        
    }
	
    // MARK: - Functions
    
    /**
    This method gets a date using the string and the format given in the parameters
    
    - parameter date:   string with the date
    - parameter format: format of the date
    
    - returns: date of the string given
    */
    static func convertDateFormater(_ date: String, format: String) -> Date {
	
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = format
        let dateD:Date
        if(date.hasPrefix("-")){
            dateD = Date()
        }
        else {
            dateD = dateFormatter.date(from: date)!
        }
		return dateD
		
	}
    
    // MARK: - Notifications
    
    static let NOTIFICATION_UPDATE_DATA = "updateData"
    static let NOTIFICATION_IMAGE_DOWNLOADED = "imageDownloaded"

}

