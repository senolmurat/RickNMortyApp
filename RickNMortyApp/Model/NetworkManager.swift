//
//  DataManager.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import Foundation

protocol NetworkManagerDelegate{
    func didFetchdata<T>(_ dataManager : NetworkManager, data: T)
    func didFailWithError(error: Error)
    func didFailWithError(error: Error , errorMessage: String)
}

struct NetworkManager{
    let rickNMortyURL = "https://rickandmortyapi.com/api/"
    
    //TODO delegate yerine closure a çevir
    var delegate : NetworkManagerDelegate?
    
    //MARK: - Character Fetching Functions
    
    func fetchAllCharacters(){
        let urlString = "\(rickNMortyURL)character"
        performRequest(with: urlString , for: CharacterResultData.self)
    }
    func fetchAllCharacters(withPage page: Int){
        let urlString = "\(rickNMortyURL)character/?page=\(page)"
        performRequest(with: urlString , for: CharacterResultData.self)
    }
    
    func fetchCharacter(withID characterID: Int){
        let urlString = "\(rickNMortyURL)character/\(characterID)"
        performRequest(with: urlString , for: Character.self)
    }
    
    func fetchMultipleCharacters(withID characterIDs : [Int]){
        let urlString = "\(rickNMortyURL)character/\(characterIDs.map{String($0)}.joined(separator: ","))"
        
        if(characterIDs.count == 0){
            return
        }
        else if(characterIDs.count == 1){
            performRequest(with: urlString , for: Character.self)
        }
        else{
            performRequest(with: urlString , for: [Character].self)
        }
    }
    
    //MARK: - Location Fetching Functions
    func fetchAllLocations(){
        let urlString = "\(rickNMortyURL)location"
        performRequest(with: urlString , for: LocationResultData.self)
    }
    
    func fetchAllLocations(withPage page: Int){
        let urlString = "\(rickNMortyURL)location/?page=\(page)"
        performRequest(with: urlString , for: LocationResultData.self)
    }
    
    func fetchLocation(withID locationID: Int){
        let urlString = "\(rickNMortyURL)location/\(locationID)"
        performRequest(with: urlString , for: Location.self)
    }
    
    func fetchMultipleLocations(withID locationIDs : [Int]){
        let urlString = "\(rickNMortyURL)location/\(locationIDs.map{String($0)}.joined(separator: ","))"
        
        if(locationIDs.count == 0){
            return
        }
        else if(locationIDs.count == 1){
            performRequest(with: urlString , for: Location.self)
        }
        else{
            performRequest(with: urlString , for: [Location].self)
        }
    }
    
    //MARK: - Episode Fetching Functions
    func fetchAllEpisodes(){
        let urlString = "\(rickNMortyURL)episode"
        performRequest(with: urlString , for: EpisodeResultData.self)
    }
    
    func fetchAllEpisodes(withPage page: Int){
        let urlString = "\(rickNMortyURL)episode/?page=\(page)"
        performRequest(with: urlString , for: EpisodeResultData.self)
    }
    
    func fetchEpisode(withID episodeID: Int){
        let urlString = "\(rickNMortyURL)episode/\(episodeID)"
        performRequest(with: urlString , for: Episode.self)
    }
    
    func fetchMultipleEpisodes(withID episodeIDs : [Int]){
        let urlString = "\(rickNMortyURL)episode/\(episodeIDs.map{String($0)}.joined(separator: ","))"
        
        if(episodeIDs.count == 0){
            return
        }
        else if(episodeIDs.count == 1){
            performRequest(with: urlString , for: Episode.self)
        }
        else{
            performRequest(with: urlString , for: [Episode].self)
        }
    }
    
    //MARK: - Helper Functions
    func performRequest<T:Decodable>(with urlString : String , for type: T.Type){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in //Completion Handler
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
                    let decodedData = parseJSON(safeData, forType: type)
                    self.delegate?.didFetchdata(self, data: decodedData)
                }
                else{
                    delegate?.didFailWithError(error: ErrorType.UnknownError)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON<T : Decodable>(_ data : Data , forType type : T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    static func ParseUrlID(with urlList : [String]) -> [Int]{
        var IDList : [Int] = []
        
        for url in urlList{
            if let IDString = url.split(separator: "/").last{
                if let ID = Int(IDString){
                    IDList.append(ID)
                }
            }
        }
        return IDList
    }
    static func ParseUrlID(with url : String) -> Int?{
        var ID : Int = 0
        
        if let IDString = url.split(separator: "/").last{
            if let _ID = Int(IDString){
                ID = _ID
            }
            else{return nil}
        }
        else{return nil}
        
        return ID
    }
    
}


