//
//  ViewController.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import FirebaseDatabase
import PKHUD
import Bond

class MovieViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var segControl    :UISegmentedControl!
    @IBOutlet var tableView     :UITableView!
    @IBOutlet var noDataLabel   :UILabel!

    var movieModel              :MovieViewModel?
    var selectedCategory        :Category = .all
    var selectedIndexPath       :IndexPath?
    var lastIndexPath           :IndexPath?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init View Model
        movieModel = MovieViewModel()
        
        //Do Binding
        self.bind()
        
        //Fetch Data from Data Center
        self.fetchServerData()
    }
    
    //MARK: Sorting
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        
        //Completion handler for Alert
        let completion: () -> Void = {
            //Reload
            self.reloadTableViewData(scrollToTop: false)
            //Collapse all cells
            self.resetIndexPathData()
        }
        
        showAlertForSort(completion: completion)
    }
    
    func showAlertForSort(completion: @escaping () -> Void) {
        
        //Construct Alert
        let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Title", style: .default) { (action:UIAlertAction) in
            self.movieModel?.sortMovies(sortBy: { ($0.headline ?? "") < ($1.headline ?? "") }, callback: {
                completion()
            })
        }
        
        let action2 = UIAlertAction(title: "Year", style: .default) { (action:UIAlertAction) in
            self.movieModel?.sortMovies(sortBy: { ($0.year ?? "") < ($1.year ?? "") }, callback: completion)
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler:nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        //Present Alert
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    //MARK: Segmented Control Change
    @IBAction func segControlValueChanged(_ sender: Any) {

        if (segControl.selectedSegmentIndex == 0) {
            fetchServerData()
            selectedCategory = .all
        }
        else {
            fetchFavoriteData()
            selectedCategory = .favorite
        }
        
        //Collapse all cells
        self.resetIndexPathData()
    }
  
    //MARK: Helpers
    func bind() {
        
        movieModel?.movies.bind(to: tableView, createCell: { (movies, indexPath, tableView) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            
            let isSelected = (indexPath.row == self.selectedIndexPath?.row)
            
            let cellModelView = MovieCellViewModel(movie: self.movieModel?.fetch(at: indexPath.row))
            
            //Configure Cell
            cell.configure(cellViewModel: cellModelView, isSelected: isSelected, segmentIndex: self.selectedCategory)
            cell.delegate = self
            return cell
            
        })
        
        segControl.reactive.bond(context: ExecutionContext) { (segmentControl, element) in
            //element
        }
        
        //segControl.reactive.controlEvents(.valueChanged).bind(to:))
    }
    
    func reloadTableViewData(scrollToTop: Bool) {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
            if (scrollToTop) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
                    self.tableView.contentOffset = CGPoint.zero
                })
            }
            
            
            let count = self.movieModel?.moviesCount ?? 0
            self.noDataLabel.alpha = (count) <= 0 ? 1.0 : 0.0
            
            HUD.flash(.success, delay: Constants.kHUDTimeout)
        }
    }

    func resetIndexPathData() {
        //Collapse all cells
        self.selectedIndexPath = nil
        self.lastIndexPath = nil
    }
}

//MARK:- UITableViewDelegate
extension MovieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


//MARK:- UITableViewDataSource
extension MovieViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = movieModel?.moviesCount ?? 0
        return count
        
    }
    
    //Commented. Now using Bond Framework implementation for cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Configure View Model
        /*let cellModelView = MovieCellViewModel(movie: movieModel?.fetch(at: indexPath.row))
        
        
        //Configure Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //Flag
        let isSelected = (indexPath.row == selectedIndexPath?.row)
        cell.configure(cellViewModel: cellModelView, isSelected: isSelected, segmentIndex: self.Category)
        cell.delegate = self
        return cell*/
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Collapse & Expand
        selectedIndexPath = indexPath
        
        var ipToReload = [selectedIndexPath!]
        
        if let _ = lastIndexPath {
            if (lastIndexPath! == selectedIndexPath) {
                selectedIndexPath = nil
            }
            else {
                ipToReload.append(lastIndexPath!)
            }
        }
        
        tableView.reloadRows(at: ipToReload, with: UITableViewRowAnimation.automatic)
        lastIndexPath = selectedIndexPath
    }
}


//MARK:- MovieCellDelegate
extension MovieViewController: MovieCellDelegate {
    
    //Home Cell Delegate
    func moreButtonPressed(cell: MovieCell) {
        
        let detail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            "DetailViewController") as! DetailViewController
        
        present(detail, animated: true, completion: nil)
    }

    func refresh() {
        print("reloading tableview")
        self.fetchFavoriteData(scrollToTop: false)
    }
    
    func showSuccessHUD() {
        DispatchQueue.main.async {
            HUD.flash(.success, delay: Constants.kHUDTimeout)
        }
    }
}


//MARK: Data Calls via VM
extension MovieViewController {

    func fetchServerData(scrollToTop: Bool = true) {
        
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
        
        movieModel?.fetchServerData(callback: {
            self.reloadTableViewData(scrollToTop: scrollToTop)
        })
    }
    
    func fetchFavoriteData(scrollToTop: Bool = true) {
        
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
        movieModel?.fetchFavoriteData(callback: {
            self.reloadTableViewData(scrollToTop: scrollToTop)
        })
    }
}

