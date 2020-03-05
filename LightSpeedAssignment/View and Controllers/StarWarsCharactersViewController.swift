//
//  ViewController.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import UIKit

class StarWarsCharactersViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var starWarsCharacter: StarWarsCharacters?
    var allCharacters: [StarWarsCharacterDetails]? = []
    var listOfCharacters: [StarWarsCharacterDetails]? = []
    var url: String? = "https://swapi.co/api/people"
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        searchBar.delegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        getCharactersOperation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func getCharactersOperation() {
        guard url != nil else {
            return
        }
        let getCharactersOperation = GetCharactersOperation(url: url) { [weak self] (charactersList, error) in
            
            guard let charactersList = charactersList else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let alert = UIAlertController(title: "Sorry, the server returned an error.", message: error?.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
                
                if error == nil {
                    self?.url = charactersList.next
                    self?.starWarsCharacter = charactersList
                    if let results = charactersList.results {
                        self?.listOfCharacters?.append(contentsOf: results)
                        self?.sortByCharacterName()
                        self!.allCharacters = self!.listOfCharacters
                        self?.tableView.reloadData()
                    }
                }
                else {
                    print(error!)
                }
            }
        }
        self.enqueueNetworkOperation(operation: getCharactersOperation)
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    
    func sortByCharacterName() {
        listOfCharacters = listOfCharacters?.sorted { $0.name < $1.name }
    }
    
}

extension StarWarsCharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""
        {
            listOfCharacters = allCharacters
        }
        else{
            listOfCharacters = allCharacters?.filter { ($0.name).contains(searchText) }
        }
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
extension StarWarsCharactersViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfCharacters?.count == 10 {
            self.getCharactersOperation()
        }
        return listOfCharacters?.count ?? 0
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.listOfCharacters!.count - 1
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.getCharactersOperation()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell() //tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        if let person = listOfCharacters?[indexPath.row] {
            cell.textLabel?.text = person.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let person = listOfCharacters?[indexPath.row]
        {
            self.performSegue(withIdentifier: "showCharacterDetails", sender: person)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CharacterDetailsViewController
        {
            let characterClicked: StarWarsCharacterDetails? = sender as? StarWarsCharacterDetails
            let vc = segue.destination as? CharacterDetailsViewController
            vc?.characterDetails = characterClicked
        }
    }
}
