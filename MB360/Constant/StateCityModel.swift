//
//  StateCityModel.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/12/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import SwiftyJSON

class StateCityCollection: NSObject {

    static let sharedInstance = StateCityCollection()
    
    func getAllCities() -> [String] {
        var cityNameArray = [String]()
        
        guard let path = Bundle.main.path(forResource: "StateCity", ofType: "json") else { return cityNameArray }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            //let newData = json.dictionaryObject
            print("Started parsing Top Up...")
            print(data)
            
            if let cityStateArray = json.array
            {
               // let cityArray = jsonResult.filter{$0["City"] }
            
                for obj in cityStateArray {
                    if let cityName = obj["city"].string
                    {
                        cityNameArray.append(cityName)
                    }
                }
                return cityNameArray
            }
            return cityNameArray

        }//do

        catch let JSONError as NSError{
            print(JSONError)
        }
        return cityNameArray
    }
    
    func getAllCitiesFrom(state:String) -> [String] {
        var cityNameArray = [String]()
        
        guard let path = Bundle.main.path(forResource: "StateCity", ofType: "json") else { return cityNameArray }
        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            //let newData = json.dictionaryObject
            print("Started parsing Top Up...")
            print(data)
            
            if let cityStateArray = json.array
            {
               // let cityArray = jsonResult.filter{$0["City"] }
                for obj in cityStateArray {
                    if let cityName = obj["city"].string
                    {
                        if state != "" {
                            if obj["state"].stringValue == state {
                            cityNameArray.append(cityName)
                            }
                        }
                        else {
                            cityNameArray.append(cityName)
                        }
                    }
                }
                
                return cityNameArray
            }
            return cityNameArray

        }//do

        catch let JSONError as NSError
        {
            print(JSONError)
        }
        return cityNameArray
    }
    
    func getStateNameFrom(selectedCity:String) -> String {
        var stateName = String()
        
        guard let path = Bundle.main.path(forResource: "StateCity", ofType: "json") else { return stateName }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            
            let json = try JSON(data: data)
            
            //let newData = json.dictionaryObject
            print("Started parsing Top Up...")
            print(data)
            
            
            if let cityStateArray = json.array
            {
               // let cityArray = jsonResult.filter{$0["City"] }
                
                for obj in cityStateArray {
                    if let cityName = obj["city"].string
                    {
                        if selectedCity != "" {
                        if obj["city"].stringValue == selectedCity {
                            stateName = obj["state"].stringValue
                            break
                        }
                        }
                        
                    }
                }
                
                return stateName
            }
            return stateName

        }//do

        catch let JSONError as NSError
        {
            print(JSONError)
        }
        return stateName
    }
    
    func getAllStates() -> [String] {
        var stateNameArray = [String]()
        
        guard let path = Bundle.main.path(forResource: "StateCity", ofType: "json") else { return stateNameArray }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            
            let json = try JSON(data: data)
            
            //let newData = json.dictionaryObject
            print("Started parsing Top Up...")
            print(data)
            
            
            if let cityStateArray = json.array
            {
               // let cityArray = jsonResult.filter{$0["City"] }
            
                for obj in cityStateArray {
                    if let stateName = obj["state"].string
                    {
                        if !(stateNameArray.contains(stateName)) {
                        stateNameArray.append(stateName)
                        }
                    }
                }
                
                return stateNameArray
            }
            return stateNameArray

        }//do

        catch let JSONError as NSError
        {
            print(JSONError)
        }
        return stateNameArray
    }
}
