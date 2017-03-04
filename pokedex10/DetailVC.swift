//
//  DetailVC.swift
//  pokedex10
//
//  Created by Spencer Forrest on 11/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        nameLbl.text = pokemon.name.capitalized
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemoDetails {
            
            self.updateUI()
            
            if !self.loadingView.isHidden {
                self.loadingView.isHidden = true
            }
        }
    }
    
    func updateUI(){
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No evolution"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            nextEvoImg.isHidden = false
            evoLbl.text = pokemon.nextEvolutionTxt
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
