//
//  CharactersViewController.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import UIKit
import SDWebImage

class CharactersTableViewController: UITableViewController {

    var dataManager = NetworkManager()
    var characterList: [Character] = []
    var totalCharacterCount: Int?
    var characterListNextPageURL: String?
    var characterListPrevPageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        loadCharacters()
        
        tableView.rowHeight = 144.0
        title = K.appName
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = characterList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CharacterCell
        cell.configue(with: character)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == characterList.count - 1{
            //Load more content
            AlertManager.showLoadingIndicator(in: self)
            
            if characterList.count < totalCharacterCount ?? 0{
                
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "tableToDetail", sender: self)
        }
    }

}

//MARK: - DataManagerDelegate Methods
extension CharactersTableViewController : NetworkManagerDelegate{

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
            AlertManager.dismiss(in: self, animated: true)
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
