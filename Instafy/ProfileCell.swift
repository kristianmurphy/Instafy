//
//  ProfileCell.swift
//  Instafy
//
//  Created by Hunter Padilla on 11/28/22.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    //Profile ImageView from 
    @IBOutlet weak var profileImageView: UIImageView!
    
    //Playlist Images based on posts from parse
    @IBOutlet weak var playlistImageView1: UIImageView!
    @IBOutlet weak var playlistImageView2: UIImageView!
    @IBOutlet weak var playlistImageView3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    

}
