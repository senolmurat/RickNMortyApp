//
//  ViewController.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    var characterId : Int?
    var character : Character?
    var dataManager = DataManager()
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusIndicator: UIImageView!
    @IBOutlet weak var SubspiciesLabel: UILabel!
    @IBOutlet weak var statusNSpeciesLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodesSeenCell: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.characterDelegate = self
        if let safeID = characterId{
            loadCharacter(with: safeID)
        }
        
        
        // Do any additional setup after loading the view.
    }

    func loadCharacter(with id : Int){
        dataManager.fetchCharacter(withID: id)
    }
    
    func applyCharacterData(with character : Character){
        
    }

}

extension CharacterDetailViewController : DataManagerCharacterDelegate{
    func didFetchdata<T>(_ dataManager: DataManager, data: T) {
        <#code#>
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didFailWithError(errorMessage: String) {
        print(errorMessage)
    }
    
    func didFetchCharacters(_ dataManager: DataManager, data: CharacterResultData) {
        character = data.results.first
        
        if let safeCharacter = character{
            DispatchQueue.main.async { [self] in
                if let imageURL = URL(string: safeCharacter.image){
                    characterImageView.load(url: imageURL)
                }
                nameLabel.text = safeCharacter.name
                switch safeCharacter.status {
                    case Status.alive.rawValue:
                        statusIndicator.tintColor = UIColor.StatusColor.alive
                        break
                    case Status.dead.rawValue:
                        statusIndicator.tintColor = UIColor.StatusColor.dead
                        break
                    case Status.unknown.rawValue:
                        statusIndicator.tintColor = UIColor.StatusColor.unknown
                        break
                    default:
                        statusIndicator.tintColor = UIColor.StatusColor.unknown
                }
                statusNSpeciesLabel.text = String("\(safeCharacter.status) - \(safeCharacter.gender) \(safeCharacter.species)")
                SubspiciesLabel.text = safeCharacter.type.isEmpty ? String("\(safeCharacter.species)") : String("\(safeCharacter.type)")
//                originLabel.text = safeCharacter.origin.name
//                locationLabel.text = safeCharacter.location.name
            }
            
            
        }
    }
    
}

