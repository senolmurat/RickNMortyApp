//
//  CharactersViewController.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 17.05.2022.
//

import UIKit

class CharactersViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var dataManager = NetworkManager()
    var characterList: [Character] = []
    var totalCharacterCount: Int?
    var characterListNextPageURL: String?
    var characterListPrevPageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dataManager.delegate = self
        
        loadCharacters()

        tableView.rowHeight = 144.0
        title = K.appName
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadCharacters(){
        dataManager.fetchAllCharacters()
    }
    

    //MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let destinationVC = segue.destination as! CharacterDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.characterId = characterList[indexPath.row].id
            destinationVC.character = characterList[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension CharactersViewController: UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = characterList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CharacterCell
        cell.configue(with: character)
        return cell
    }

}

//MARK: - TableView Delegate Methods
extension CharactersViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == characterList.count - 1{
            
            //Check if there are anymore characters to load
            if characterList.count < totalCharacterCount ?? 0{
                //Load more content
                //AlertManager.showLoadingIndicator(in: self)
                AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                
                if let url = characterListNextPageURL{
                    let queryItems = URLComponents(string: url)?.queryItems
                    if let pageItem = queryItems?.filter({$0.name == "page"}).first{
                        if let pageString = pageItem.value {
                            if let page = Int(pageString){
                                dataManager.fetchAllCharacters(withPage: Int(page))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CharacterDetailViewController.self)) as? CharacterDetailViewController{
            
            //Preperation
            if let indexPath = tableView.indexPathForSelectedRow{
                detailVC.characterId = characterList[indexPath.row].id
                detailVC.character = characterList[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: false)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - DataManager Delegeate Methods
extension CharactersViewController : NetworkManagerDelegate{
    
    func didFetchdata<T>(_ dataManager: NetworkManager, data: T) {
        if let resultData = data as? CharacterResultData{
            if totalCharacterCount == nil{
                totalCharacterCount = resultData.info?.count
            }
            characterList.append(contentsOf: resultData.results)
            characterListNextPageURL = resultData.info?.next
            characterListPrevPageURL = resultData.info?.prev
        }
        DispatchQueue.main.async {
            AlertManager.hideTableViewLoadingIndicator(for: self.tableView, in: self)
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self , handler: nil)
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        AlertManager.showInfoAlertBox(with: errorMessage, in: self , handler: nil)
    }
}
