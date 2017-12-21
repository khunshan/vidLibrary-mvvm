//
//  MovieCell.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit

protocol MovieCellDelegate: class {
    func moreButtonPressed(cell: MovieCell)
}

class MovieCell: UITableViewCell {
    
    @IBOutlet var leftImageView     : UIImageView!
    @IBOutlet var titleLabel        : UILabel!
    @IBOutlet var subtitleLabel     : UILabel!
    @IBOutlet var descriptionLabel  : UILabel!
    
    weak var delegate:MovieCellDelegate?
    weak var weakSelf:MovieCell?
    
    //MARK: - Configure
    func configure(cellViewModel: MovieCellViewModel, isSelected: Bool) {
        
        //Populate Cell
        titleLabel.text     = cellViewModel.movieTitle
        subtitleLabel.text  = cellViewModel.movieYear
        
        if let urlString = cellViewModel.movieImageUrl {
            let url = URL(string: urlString)
            leftImageView.kf.setImage(with: url)
        }
        else {
            leftImageView.image = UIImage(named: "noImage")
        }
        
        //Is Selected Cell Check
        descriptionLabel.numberOfLines = isSelected ? 0 : 1
        descriptionLabel.text = isSelected ? cellViewModel.movieDetails : ""
    }
    
    //MARK: - More Button
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        weakSelf = self
        delegate?.moreButtonPressed(cell: weakSelf!)
    }
    
}
