//
//  csvData.swift
//  pokedex10
//
//  Created by Spencer Forrest on 11/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import Foundation

/**
 Give access to each pokemon id and pokemon name one by one
 
 - Parameter writeCode: closure where you receive the data
 - Parameter id: pokemon id as Integer
 - Parameter name: pokemon name as String
 */
func parsePokeCSV(writeCode: (_ id: Int,_ name: String)->()){
    let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
    
    do {
        let csv = try CSV(contentsOfURL: path)
        let rows = csv.rows
        //print(rows)
        
        for row in rows {
            let pokeID = Int(row["id"]!)!
            let name = row["identifier"]!
            
            writeCode(pokeID, name)
        }
    } catch  let err as NSError {
        print(err.debugDescription)
    }
}
