//
//  LocationViewController.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 17.05.2022.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var locationID : Int?
    
    var dataManager = NetworkManager()
    var characterList: [Character] = []
    var characterIDList : [Int] = []
    var totalCharacterCount: Int?
    
    let characterBuffer = 19 // (20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dataManager.delegate = self
        
        if let safeID = locationID{
            //AlertManager.ShowLoadingIndicator(in: self)
            loadLocation(with: safeID)
        }

        tableView.rowHeight = 144.0
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    func loadLocation(with locationID : Int){
        dataManager.fetchLocation(withID: locationID)
    }
    
    func applyLocationData(with location : Location){
        
        DispatchQueue.main.async { [self] in
            title = location.name
            typeLabel.text = "Type: " + location.type
            dimensionLabel.text = "Dimension: " + location.dimension
        }
        characterIDList = NetworkManager.ParseUrlID(with: location.residents)
        totalCharacterCount = characterIDList.count
        
        let currentBufferStart = characterList.count
        var currentBufferEnd = currentBufferStart + characterBuffer
        if(currentBufferEnd >= characterIDList.count){
            currentBufferEnd = characterIDList.count - 1
        }
        dataManager.fetchMultipleCharacters(withID: characterIDList[currentBufferStart...currentBufferEnd].map { Int($0) })
    }
    
}

//MARK: - TableView DataSource Methods
extension LocationViewController: UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Residents"
    }

}


//MARK: - TableView Delegate Methods
extension LocationViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == characterList.count - 1{
            //Check if there are anymore characters to load
            if characterList.count < totalCharacterCount ?? 0{
                //Load more content
                AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                
                let currentBufferStart = characterList.count
                var currentBufferEnd = currentBufferStart + characterBuffer
                if(currentBufferEnd >= characterIDList.count){
                    currentBufferEnd = characterIDList.count - 1
                }
                dataManager.fetchMultipleCharacters(withID: characterIDList[currentBufferStart...currentBufferEnd].map { Int($0) })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CharacterDetailViewController.self)) as? CharacterDetailViewController{
            
            //Preperation
            if let indexPath = tableView.indexPathForSelectedRow{
                detailVC.previousLocationID = locationID
                detailVC.characterId = characterList[indexPath.row].id
                detailVC.character = characterList[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: false)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


//MARK: - DataManager Delegeate Methods
extension LocationViewController : NetworkManagerDelegate{
    
    func didFetchdata<T>(_ dataManager: NetworkManager, data: T) {
        if let resultData = data as? [Character]{
            if totalCharacterCount == nil{
                totalCharacterCount = resultData.count
            }
            characterList.append(contentsOf: resultData)
            
            DispatchQueue.main.async {
                AlertManager.hideTableViewLoadingIndicator(for: self.tableView, in: self)
                self.tableView.reloadData()
            }
        }
        else if let resultData = data as? Location{
            applyLocationData(with: resultData)
            
            DispatchQueue.main.async {
                AlertManager.dismiss(in: self, animated: true)
            }
        }
        else if let resultData = data as? Character{
            characterList.append(resultData)
            
            DispatchQueue.main.async {
                AlertManager.hideTableViewLoadingIndicator(for: self.tableView, in: self)
                self.tableView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self , handler: nil)
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        AlertManager.showInfoAlertBox(with: errorMessage, in: self , handler: nil)
    }
}

