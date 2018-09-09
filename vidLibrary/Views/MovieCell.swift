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
    func refresh()
    func showSuccessHUD()
}

class MovieCell: UITableViewCell {
    
    
    @IBOutlet var leftImageView     : UIImageView!
    @IBOutlet var titleLabel        : UILabel!
    @IBOutlet var subtitleLabel     : UILabel!
    @IBOutlet var descriptionLabel  : UILabel!
    @IBOutlet var favoriteButton    : UIButton!

    weak var delegate   :MovieCellDelegate?
    weak var weakSelf   :MovieCell?
    var cellViewModel   :MovieCellViewModel?
    var segmentIndex    :SegIndex?
    
    
    //MARK: - Configure
    func configure(cellViewModel: MovieCellViewModel, isSelected: Bool, segmentIndex: SegIndex = .all) {
        self.cellViewModel = cellViewModel
        self.segmentIndex = segmentIndex
        
        //Populate Cell
        titleLabel.text     = cellViewModel.movieTitle
        subtitleLabel.text  = cellViewModel.movieYear
        
        if let urlString = cellViewModel.movieImageUrl {
            let url = URL(string: urlString)
            leftImageView.kf.setImage(with: url)
        }
        else {
            leftImageView.image = UIImage(named: Constants.kNoImage)
        }
        
        //Is Selected Cell Check
        descriptionLabel.numberOfLines = isSelected ? 0 : 1
        descriptionLabel.text = isSelected ? cellViewModel.movieDetails : ""
        
        
        let favoriteButtonTitle = (segmentIndex == .favorite) ? "DEL" : "⭐️"
        favoriteButton.setTitle(favoriteButtonTitle, for: .normal)
        
    }
    
    //MARK: - Button Actions
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        weakSelf = self
        delegate?.moreButtonPressed(cell: weakSelf!)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {

        if self.segmentIndex == .favorite{
            cellViewModel?.deleteFavorite()
            delegate?.refresh()
        }
        else {
            cellViewModel?.saveFavorite()
            delegate?.showSuccessHUD()
        }
    }
    
}
