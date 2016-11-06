//
//  Pokemon.swift
//  pokedex
//
//  Created by c.uraga on 2016/09/04.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name:String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL:  String!
    
    var nextEvolutionName: String{
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String{
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var name:String {
        get {
            return _name
        }
    }
    
    var pokedexId:Int {
        get {
            return _pokedexId

        }
    }
    var description: String{
        get {
            if _description == nil {
                _description = ""
            }

            return _description
        }
        
    }
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)/\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        print("URLTOSEE: " + _pokemonURL)
        Alamofire.request(_pokemonURL, withMethod: .get).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    var typeToSet = ""
                    var counter = 0
                    for typeDictionary in types {
                        if let type =  typeDictionary["name"] as? String {
                            typeToSet += type.capitalized
                            if counter != types.count - 1 {
                                typeToSet += "/"
                            }
                            counter += 1
                        }
                    }
                    self._type = typeToSet
                }
                else {
                    self._type =  ""
                }
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>], descriptionArray.count > 0 {
                    if let url = descriptionArray[0]["resource_uri"] {
                        Alamofire.request("\(URL_BASE)\(url)", withMethod: .get).responseJSON(completionHandler: { response in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    print(description)
                                    self._description = newDescription
                                }
                            }
                            completed()
                        
                            })
                    }
                }
                else {
                    self._description = ""
                }
                
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            //only if it's not mega
                            self._nextEvolutionName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                                let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoID
                            }
                            
                            if let lvlExists = evolutions[0]["level"] {
                                if let lvl = lvlExists as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                            }
                            else{
                                self._nextEvolutionLevel = ""
                            }
                        }
                    }
                }
            }
             completed()
            
        }
    }
    

}
