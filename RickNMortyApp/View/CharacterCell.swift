//
//  CharacterCell.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import UIKit

class CharacterCell: UITableViewCell {

    
    @IBOutlet weak var characterCardView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusIndicatorImageView: UIImageView!
    @IBOutlet weak var statusNSpeciesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        characterImageView.layer.masksToBounds = true
        characterImageView.layer.cornerRadius = characterImageView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //TODO Change this  , move the constraints to cell view itself
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func configue(with character: Character){
        //INFO Could use SDWebImage ( https://github.com/SDWebImage/SDWebImage ) for ımages in table view
        
        if let imageURL = URL(string: character.image){
            characterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: K.defaultCharacterImage))
        }
        
        nameLabel.text = character.name
        statusNSpeciesLabel.text = character.statusNSpecieString
        
        switch character.status {
            case Status.alive.rawValue:
                statusIndicatorImageView.tintColor = UIColor.StatusColor.alive
                break
            case Status.dead.rawValue:
                statusIndicatorImageView.tintColor = UIColor.StatusColor.dead
                break
            case Status.unknown.rawValue:
                statusIndicatorImageView.tintColor = UIColor.StatusColor.unknown
                break
            default:
                statusIndicatorImageView.tintColor = UIColor.StatusColor.unknown
        }
        
    }
    
}
