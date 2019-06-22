//
//  Launches.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/2/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

protocol UpcomingLaunchesDelegate
{
    func finishedLoading()
}

class UpcomingLaunches: NSObject
{
    //  Singleton
    static let shared = UpcomingLaunches()
    
    //  Properties
    private var allLaunches:       [Launch]!
    private var spacexLaunches:    SpaceXLaunches!
    private var rocketLabLaunches: RocketLabLaunches!
    private var ulaLaunches:       ULALaunches!
    
    private var session:           URLSession!
    var         delegate:          UpcomingLaunchesDelegate?
    
    private let totalTask:         Int = 3
    private var finishedTask:      Int!
    
    //  Getters
    var getAllLaunches: [Launch] {
        var launches: [Launch] = []
        
        if spacexLaunches != nil
        {
            for launch in spacexLaunches.launches
            {
                launches.append(launch)
            }
        }
        if rocketLabLaunches != nil
        {
            for launch in rocketLabLaunches.launches
            {
                launches.append(launch)
            }
        }
        if ulaLaunches != nil
        {
            for launch in ulaLaunches.launches
            {
                launches.append(launch)
            }
        }
        return launches
    }
    var getSpacexLaunches: SpaceXLaunches {
        return spacexLaunches
    }
    var getRocketLabLaunches: RocketLabLaunches {
        return rocketLabLaunches
    }
    var getULALaunches: ULALaunches {
        return ulaLaunches
    }
    
    private override init()
    {
        super.init()
        let config = URLSessionConfiguration.background(withIdentifier: SESSION_ID)
        session = URLSession.init(configuration: config, delegate: self, delegateQueue: nil)
        refresh()
    }
    
    func refresh()
    {
        finishedTask = 0
        for lsp in lspIDs.allCases
        {
            guard let url = URL(string: urlBase + lsp.rawValue + urlEnding) else { break }
            let task = session.downloadTask(with: url)
            task.taskDescription = lsp.rawValue
            task.resume()
        }
    }
    
    private func parseLaunchLibrary(_jsonObj: Any?, _lspId: lspIDs) -> [Launch]
    {
         var dataModel: [Launch] = []
        
        guard let json = _jsonObj as? Dictionary<String, Any>,
            let launches = json["launches"] as? [Any]
            else { print("SpaceX Data Parse Error"); return dataModel }
        
        for launch in launches
        {
            guard let launchJson = launch as? Dictionary<String, Any>,
                let id = launchJson["id"] as? Int,
                let name = launchJson["name"] as? String,
                let netTime = launchJson["net"] as? String,
                let location = launchJson["location"] as? Dictionary<String, Any>,
                let pads = location["pads"] as? [Any],
                let padData = pads[0] as? Dictionary<String, Any>,
                let padName = padData["name"] as? String,
                let missions = launchJson["missions"] as? [Any]
                else { print("Data Parse Error"); return dataModel }
            
            var splitName = name.split(separator: "|")
            guard let mission = splitName.popLast()?.description.trimmingCharacters(in: .whitespaces),
                let rocket = splitName.popLast()?.description.trimmingCharacters(in: .whitespaces)
                else
            {
                print("Name Split Error")
                return dataModel
            }
            
            var customer = "Unknown"
            if missions.count > 0
            {
                if let primaryMission = missions[0] as? Dictionary<String, Any>,
                    let agencies = primaryMission["agencies"] as? [Any],
                    agencies.count > 0
                {
                    if let primaryAgency = agencies[0] as? Dictionary<String, Any>,
                        let agency = primaryAgency["abbrev"] as? String
                    {
                        customer = agency
                    }
                }
            }
            
            let parsedData = Launch(
                _id:       id,
                _mission:  mission,
                _rocket:   rocket,
                _netTime:  netTime,
                _location: padName,
                _agency:   customer)
            
            if _lspId == .SpaceX
            {
                dataModel.append(Launch(_launch: parsedData, _name: "SpaceX", _color: SPACEX_COLOR))
            }
            else if _lspId == .RocketLab
            {
                dataModel.append(Launch(_launch: parsedData, _name: "Rocket Lab", _color: ROCKETLAB_COLOR))
            }
            else if _lspId == .ULA
            {
                dataModel.append(Launch(_launch: parsedData, _name: "ULA", _color: ULA_COLOR))
            }
        }
        
        dataModel.sort { (alpha, bravo) -> Bool in
            
        }
        return dataModel
    }
}

extension UpcomingLaunches: URLSessionDelegate {}

extension UpcomingLaunches: URLSessionTaskDelegate
{
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        finishedTask += 1
        if (finishedTask == 3)
        {
            delegate?.finishedLoading()
        }
    }
}

extension UpcomingLaunches: URLSessionDownloadDelegate
{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        var rawData: Data? = nil
        do
        {
            rawData = try Data(contentsOf: location)
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        guard let checkRawData = rawData,
            let taskDescription = downloadTask.taskDescription
            else { print("Error in Raw Data Check"); return }
        
        var jsonObj: Any? = nil
        do
        {
            jsonObj = try JSONSerialization.jsonObject(with: checkRawData, options: .mutableContainers)
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        if taskDescription == lspIDs.SpaceX.rawValue
        {
            let launches = parseLaunchLibrary(_jsonObj: jsonObj, _lspId: .SpaceX)
            if launches.count > 0
            {
                spacexLaunches = SpaceXLaunches(_launches: launches)
            }
        }
        else if taskDescription == lspIDs.RocketLab.rawValue
        {
            let launches = parseLaunchLibrary(_jsonObj: jsonObj, _lspId: .RocketLab)
            if launches.count > 0
            {
                rocketLabLaunches = RocketLabLaunches(_launches: launches)
            }
        }
        else if taskDescription == lspIDs.ULA.rawValue
        {
            let launches = parseLaunchLibrary(_jsonObj: jsonObj, _lspId: .ULA)
            if launches.count > 0
            {
                ulaLaunches = ULALaunches(_launches: launches)
            }
        }
    }
}

class Launches
{
    var launches: [Launch]
    
    init (_launches: [Launch])
    {
        launches = _launches
    }
}

class SpaceXLaunches: Launches
{
    override init(_launches: [Launch])
    {
        super.init(_launches: _launches)
    }
}

class RocketLabLaunches: Launches
{
    override init(_launches: [Launch])
    {
        super.init(_launches: _launches)
    }
}

class ULALaunches: Launches
{
    override init(_launches: [Launch])
    {
        super.init(_launches: _launches)
    }
}

class Launch
{
    var id:       Int
    var mission:  String
    var rocket:   String
    var netTime:  String
    var location: String
    var agency:   String
    var image:    UIImage?
    var name:     String?
    var color:    UIColor?
    
    init(_id: Int, _mission: String, _rocket: String, _netTime: String, _location: String, _agency: String) {
        id       = _id
        mission  = _mission
        rocket   = _rocket
        netTime  = _netTime
        location = _location
        agency   = _agency
        
        let dateFormatter = DateFormatter()
        
    }
    
    init (_launch: Launch, _name: String, _color: UIColor)
    {
        id       = _launch.id
        mission  = _launch.mission
        rocket   = _launch.rocket
        netTime  = _launch.netTime
        color    = _color
        name     = _name
        location = _launch.location
        agency   = _launch.agency
        
        if rocket == "Atlas V 551"
        {
            image = UIImage(named: "AtlasV551")
        }
        else if rocket == "Falcon Heavy"
        {
            image = UIImage(named: "FalconHeavy")
        }
        else if rocket == "Falcon 9 Block 5"
        {
            image = UIImage(named: "Falcon9Block5")
        }
        else if rocket == "Electron"
        {
            image = UIImage(named: "Electron")
        }
        else if rocket == "Delta IV M+(4,2)"
        {
            image = UIImage(named: "DeltaIVM")
        }
        else
        {
            print(rocket)
            image = nil
        }
    }
}

//  CONSTANTS
private let urlBase = "https://launchlibrary.net/1.4/launch?mode=verbose&lsp="
private let urlEnding = "&next=5"
private enum lspIDs: String, CaseIterable {
    case SpaceX    = "121"
    case RocketLab = "147"
    case ULA       = "124"
}
private let SESSION_ID = "SESSION_ID"
private let SPACEX_COLOR    = UIColor(red:   0/255, green: 111/255, blue: 186/255, alpha: 1.0)
private let ULA_COLOR       = UIColor(red:   0/255, green:  59/255, blue: 119/255, alpha: 1.0)
private let ROCKETLAB_COLOR = UIColor(red: 215/255, green:  32/255, blue:   2/255, alpha: 1.0)
