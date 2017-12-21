//
//  HomeCell.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit

protocol HomeCellDelegate: class {
    func moreButtonPressed(cell: HomeCell)
}

class HomeCell: UITableViewCell {
    
    @IBOutlet var leftImageView     : UIImageView!
    @IBOutlet var titleLabel        : UILabel!
    @IBOutlet var subtitleLabel     : UILabel!
    @IBOutlet var descriptionLabel  : UILabel!
    
    weak var delegate:HomeCellDelegate?
    weak var weakSelf:HomeCell?
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        weakSelf = self
        delegate?.moreButtonPressed(cell: weakSelf!)
    }
    
}
