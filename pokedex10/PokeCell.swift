//
//  PokeCell.swift
//  pokedex10
//
//  Created by Spencer Forrest on 10/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    
    /**
     Set up the data for the PokeCell (UICollectionViewCell)
     - Parameter name: Name of Pokemon
     - Parameter id: Id of Pokemon
    */
    func configureCell(_ name: String,_ id: Int){
        namelbl.text = name
        thumbImage.image = UIImage(named: "\(id)")
    }
}
