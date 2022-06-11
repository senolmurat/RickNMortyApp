//
//  ViewController.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {

    var characterId : Int?
    var character : Character?
    var dataManager = NetworkManager()
    var previousLocationID : Int?
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var statusIndicator: UIImageView!
    @IBOutlet weak var subspiciesLabel: UILabel!
    @IBOutlet weak var statusNSpeciesLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var originDisclosureIndicatorImageView: UIImageView!
    @IBOutlet weak var locationDisclosureIndicatorImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        
        if let safeCharacter = character{
            applyCharacterData(with: safeCharacter)
        }
        else if let safeID = characterId{
            AlertManager.showLoadingIndicator(in: self)
            loadCharacter(with: safeID)
        }
        else{
            AlertManager.showInfoAlertBox(with: "Karakter Bulunamadı.", in: self) { action in
                self.navigationController?.popViewController(animated: true)
            }
        }

        if shouldPushViewController(withIdentifier: nil, check: "Origin" ,sender: self) {
            let originViewGesture = UITapGestureRecognizer(target: self, action:  #selector (self.originViewClicked(_:)))
            self.originView.addGestureRecognizer(originViewGesture)
            originDisclosureIndicatorImageView.isHidden = false
        }
        if shouldPushViewController(withIdentifier: nil, check: "Location" ,sender: self) {
            let locationViewGesture = UITapGestureRecognizer(target: self, action:  #selector (self.locationViewClicked(_:)))
            self.locationView.addGestureRecognizer(locationViewGesture)
            locationDisclosureIndicatorImageView.isHidden = false
        }
        
    }

    func loadCharacter(with id : Int){
        dataManager.fetchCharacter(withID: id)
    }
    
    func applyCharacterData(with character : Character){
        DispatchQueue.main.async { [self] in
            
            title = character.name
            if let imageURL = URL(string: character.image){
                characterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: K.defaultCharacterImage))
            }
            switch character.status {
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
            statusNSpeciesLabel.text = String("\(character.status) - \(character.gender) \(character.species)")
            subspiciesLabel.text = character.type.isEmpty ? String("\(character.species)") : String("\(character.type)")
                originLabel.text = character.origin.name
                locationLabel.text = character.location.name
        }
    }
    
    

    @objc func originViewClicked(_ sender:UITapGestureRecognizer){
        if shouldPushViewController(withIdentifier: String(describing: LocationViewController.self), check: "Origin" ,sender: self) {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LocationViewController.self)) as? LocationViewController{
                //Preperation
                detailVC.locationID = NetworkManager.ParseUrlID(with: character!.origin.url)
                
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    @objc func locationViewClicked(_ sender:UITapGestureRecognizer){
        if shouldPushViewController(withIdentifier: String(describing: LocationViewController.self), check: "Location" ,sender: self) {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LocationViewController.self)) as? LocationViewController{
                //Preperation
                detailVC.locationID = NetworkManager.ParseUrlID(with: character!.location.url)
                
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    //MARK: - Navigation Methods
    
    func shouldPushViewController(withIdentifier identifier: String?, check : String , sender: Any? ) -> Bool {
        
        guard let safeCharacter = character else{
            return false
        }

        if check == "Origin"{
            if let originID = NetworkManager.ParseUrlID(with: safeCharacter.origin.url){
                if originID != self.previousLocationID{
                    return true
                }
            }
        }
        else if check == "Location"{
            if let locationID = NetworkManager.ParseUrlID(with: safeCharacter.location.url){
                if locationID != self.previousLocationID{
                    return true
                }
            }
        }
        
        return false
    }
    
//    //MARK: - Segue Methods
//
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
//        guard let safeCharacter = character else{
//            return false
//        }
//
//
//        if identifier == "originToLocation"{
//            if let originID = DataManager.ParseUrlID(with: safeCharacter.origin.url){
//                if originID != self.previousLocationID{
//                    return true
//                }
//            }
//        }
//        else if identifier == "lastToLocation"{
//            if let locationID = DataManager.ParseUrlID(with: safeCharacter.location.url){
//                if locationID != self.previousLocationID{
//                    return true
//                }
//            }
//        }
//
//        return false
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let destinationVC = segue.destination as! LocationViewController
//
//        if segue.identifier == "originToLocation"{
//            destinationVC.locationID = DataManager.ParseUrlID(with: character!.origin.url)
//        }
//        else if segue.identifier == "lastToLocation"{
//            destinationVC.locationID = DataManager.ParseUrlID(with: character!.location.url)
//        }
//    }
}

extension CharacterDetailViewController : NetworkManagerDelegate{
    
    func didFetchdata<T>(_ dataManager: NetworkManager, data: T) {
        if let resultData = data as? Character{
            character = resultData
            applyCharacterData(with: resultData)
            DispatchQueue.main.async {
                AlertManager.dismiss(in: self, animated: true)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self ,handler: nil)
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        AlertManager.showInfoAlertBox(with: errorMessage, in: self , handler: nil)
    }
}

