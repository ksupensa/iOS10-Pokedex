//
//  MainVC.swift
//  pokedex10
//
//  Created by Spencer Forrest on 07/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var uisearchBar: UISearchBar!
    @IBOutlet weak var collection: PokeCollection!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        uisearchBar.delegate = self
        
        uisearchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokeCSV {
            id, name in
            let pokemon = Pokemon(name: name, pokedexId: id)
            pokemons.append(pokemon)
        }
        
    /*
        parsePokeCSV {
            let pokemon = Pokemon(name: $0, pokedexId: $1)
            pokemons.append(pokemon)
        }
    */
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        initAudio()
    }
    
    func dismissKeyboard(){
        uisearchBar.resignFirstResponder()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchText.characters.count == 0 {
            inSearchMode = false
            searchBar.resignFirstResponder()
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemons = pokemons.filter({pokemon in pokemon.name.range(of: lower) != nil})
        /*
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil})
        */
        }
        collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = inSearchMode ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
        performSegue(withIdentifier: "DetailVC", sender: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC"{
            if let detailVC = segue.destination as? DetailVC{
                if let pokemon = sender as? Pokemon{
                    detailVC.pokemon = pokemon
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemons.count : pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let pokemon = inSearchMode ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
            
            cell.configureCell(pokemon.name, pokemon.pokedexId)
            
            return cell
        }
        return UICollectionViewCell()
    }
}
