//
//  Launches_DM.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 12/11/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import Foundation

struct DataModel: Decodable {
    var launches: [Launch]
}

struct Launch: Decodable {
    var name: String
//    {
//        return rocket.name + " | " + missions[0].name
//    }
    var windowstart: String
    var windowend: String
    var status: Int
    var location: Location
    var rocket: Rocket
    var missions: [Mission]
    var lsp: LSP
    
    func getFormattedTime() -> (start: String, end: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy HH:mm:ss z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcStartDate = dateFormatter.date(from: windowstart)
        let utcEndDate = dateFormatter.date(from: windowend)
        
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let localStartDate = dateFormatter.string(from: utcStartDate!)
        let localEndDate = dateFormatter.string(from: utcEndDate!)
        
        return (localStartDate, localEndDate)
        
    }
    
    func toString() {
        print("Name: \(name)")
        print("Window Start: \(windowstart)")
        print("Window End: \(windowend)")
        print("Status: \(status)")
        print("Location")
        location.toString()
        print("Rocket")
        rocket.toString()
        print("Missions")
        for m in missions {
            m.toString()
        }
        print("LSP")
        lsp.toString()
    }
}

struct Location: Decodable {
    var name: String
    var pads: [Pad]
    
    func toString() {
        print("     Name: \(name)")
        print("Pads")
        for p in pads {
            p.toString()
        }
    }
}

struct Pad: Decodable {
    var name: String
    
    func toString() {
        print("         Name: \(name)")
    }
}

struct Rocket: Decodable {
    var name: String
    
    func toString() {
        print("     Name: \(name)")
    }
}

struct Mission: Decodable {
    var name: String
    var description: String
    
    func toString() {
        print("     Name: \(name)")
        print("     Description: \(description)")
    }
}

struct LSP: Decodable {
    var name: String
    
    func toString() {
        print("     Name: \(name)")
    }
}
