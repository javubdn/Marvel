//
//  Constants.swift
//  Marvel
//
//  Created by Javi Castillo Risco on 21/2/16.
//  Copyright © 2016 Javi Castillo Risco. All rights reserved.
//

import Foundation

struct Constants {
    static let myConstant = 5
    
    enum TypeData : Int {
        case    NoValue = 0
        case    Characters, Comics, Creators, Events, Series, Stories
        
        func getDescription() -> String {
            switch self {
            case .NoValue:
                return ""
            case .Characters:
                return "characters"
            case .Comics:
                return "comics"
            case .Creators:
                return "creators"
            case .Events:
                return "events"
            case .Series:
                return "series"
            case .Stories:
                return "stories"
            }
        }
		
		func getTable() -> String {
			switch self {
			case .NoValue:
				return ""
			case .Characters:
				return "Character"
			case .Comics:
				return "Comic"
			case .Creators:
				return "Creator"
			case .Events:
				return "Event"
			case .Series:
				return "Serie"
			case .Stories:
				return "Story"
			}
		}
		
        static func getValue(value:Int) -> TypeData {
            switch value {
            case 0:
                return .Characters
            case 1:
                return .Comics
            case 2:
                return .Creators
            case 3:
                return .Events
            case 4:
                return .Series
            case 5:
                return .Stories
            default:
                return .NoValue
            }
        }
        
    }
	
	static func convertDateFormater(date: String) -> NSDate {
	
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
		let dateD:NSDate = dateFormatter.dateFromString(date)!

		return dateD
		
	}

}

