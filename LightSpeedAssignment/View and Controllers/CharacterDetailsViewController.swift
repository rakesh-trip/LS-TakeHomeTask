//
//  CharacterDetailCollectionViewCell.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var characterGenderLabel: UILabel!
    @IBOutlet weak var characterHairColorLabel: UILabel!
    @IBOutlet weak var characterSkinColorLabel: UILabel!
    @IBOutlet weak var characterEyeColorLabel: UILabel!
    @IBOutlet weak var filmsCollectionView: UICollectionView!
    
    var films: [FilmDetails]? = []
    var characterDetails: StarWarsCharacterDetails?
    
    override func viewDidLoad() {
        filmsCollectionView.dataSource = self
        filmsCollectionView.delegate = self
        characterNameLabel.text = "Name: " + (characterDetails?.name ?? "Unavailable")
        dateOfBirthLabel.text = "DOB: " + (characterDetails?.birth_year ?? "Unavailable")
        characterGenderLabel.text = "Gender: " +  (characterDetails?.gender ?? "Unavailable")
        characterHairColorLabel.text = "Hair Color: " + (characterDetails?.hair_color ?? "Unavailable")
        characterSkinColorLabel.text = "Skin Color: " + (characterDetails?.skin_color ?? "Unavailable")
        characterEyeColorLabel.text = "Eye Color: " + (characterDetails?.eye_color ?? "Unavailable")
        self.fetchFilms(urls: characterDetails?.films)
    }
    
    func fetchFilms(urls: [String]?) {
        guard urls != nil else {
            return
        }
        for url in urls! {
            self.fetchFilmDetails(url: url)
        }
    }
    
    func fetchFilmDetails(url: String) {
        let fetchOperation = GetFilmDetailsOperation(url: url) { [weak self]  (filmDetails, error) in
            
            guard let filmDetails = filmDetails else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let alert = UIAlertController(title: "Sorry, the server returned an error.", message: error?.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
                return
            }
            DispatchQueue.main.async {
                if error == nil {
                    self?.films?.append(filmDetails)
                    self?.filmsCollectionView.reloadData()
                }
                else {
                    print(error!)
                }
            }
        }
        self.enqueueNetworkOperation(operation: fetchOperation)
    }
    
}


extension CharacterDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.films?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCollectionViewCell", for: indexPath) as! FilmCollectionViewCell
        if let film = self.films?[indexPath.item] {
            cell.titleLabel.text = film.title
            cell.wordCountLabel.text = "\(film.openingCrawlWordCount)"
        }
        return cell
    }
}
