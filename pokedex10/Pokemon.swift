//
//  Pokemon.swift
//  pokedex10
//
//  Created by Spencer Forrest on 08/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
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
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var pokemonURL: String {
        if _pokemonURL == nil {
            _pokemonURL = ""
        }
        return _pokemonURL
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            self._nextEvolutionName = ""
        }
        return self._nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            self._nextEvolutionId = ""
        }
        return self._nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            self._nextEvolutionLvl = ""
        }
        return self._nextEvolutionLvl
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(pokedexId)"
    }
    
    func downloadPokemoDetails(completed: @escaping DownloadCompleted){
        Alamofire.request(_pokemonURL).responseJSON {
            (response) in
            
            if let dictionary = response.result.value as? Dictionary<String, Any> {
                if let weight = dictionary["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dictionary["height"] as? String {
                    self._height = height
                }
                
                if let attack = dictionary["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dictionary["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dictionary["types"] as? [Dictionary<String, String>], types.count > 0 {
                    for x in 0..<types.count {
                        if let name = types[x]["name"] {
                            if x == 0 {
                                self._type = name.capitalized
                            } else {
                                self._type = "\(self._type!)/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = "No known type"
                }
                
                if let descriptions = dictionary["descriptions"] as? [Dictionary<String, String>], descriptions.count > 0 {
                    
                    if let url = descriptions[0]["resource_uri"] {
                        
                        let descURL = "\(BASE_URL)\(url)"
                        
                        Alamofire.request(descURL).responseJSON {
                            response in
                            
                            if let descDict = response.result.value as? Dictionary<String, Any> {
                                
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokémon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = "No Description"
                }
                
                if let evolutions = dictionary["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "api/v1/pokemon/" , with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                            }
                            
                            if let lvlExist = evolutions[0]["level"] as? Int{
                                self._nextEvolutionLvl = " - LVL \(lvlExist)"
                            } else {
                                self._nextEvolutionLvl = ""
                            }
                            
                            self._nextEvolutionTxt = "Next Evolution: \(self.nextEvolutionName)\(self.nextEvolutionLvl)"
                        }
                    }
                }
                
            }
            completed()
        }
    }
}
