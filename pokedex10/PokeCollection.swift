//
//  PokeCollection.swift
//  pokedex10
//
//  Created by Spencer Forrest on 10/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

class PokeCollection: UICollectionView, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
}
