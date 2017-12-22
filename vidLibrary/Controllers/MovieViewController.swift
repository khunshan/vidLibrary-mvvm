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

class MovieViewController: UIViewController {
    
    
    //MARK: Properties
    @IBOutlet var segControl    :UISegmentedControl!
    @IBOutlet var tableView     :UITableView!
    
    var movieModel              :MovieViewModel?
    var segIndex                :SegIndex = .all
    var selectedIndexPath       :IndexPath?
    var lastIndexPath           :IndexPath?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init View Model
        movieModel = MovieViewModel()
        
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
            self.selectedIndexPath = nil
            self.lastIndexPath = nil
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

        if (segControl.selectedSegmentIndex == SegIndex.all.rawValue) {
            fetchServerData()
            self.segIndex = .all
        }
        else {
            fetchFavoriteData()
            self.segIndex = .favorite
        }
    }
    
    //MARK: Data Calls
    func fetchServerData(scrollToTop: Bool = true) {
        movieModel?.fetchServerData(callback: {
            self.reloadTableViewData(scrollToTop: scrollToTop)
        })
    }
    
    func fetchFavoriteData(scrollToTop: Bool = true) {
        movieModel?.fetchFavoriteData(callback: {
            self.reloadTableViewData(scrollToTop: scrollToTop)
        })
    }
  
    //MARK: Helper
    func reloadTableViewData(scrollToTop: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if (scrollToTop) {
                self.tableView.setContentOffset(
                    CGPoint(x: 0, y: -40),animated: false)
            }
        }
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
        return movieModel?.moviesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Configure View Model
        let cellModelView = MovieCellViewModel(movie: movieModel?.fetch(at: indexPath.row))
        
        
        //Configure Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //Flag
        let isSelected = (indexPath.row == selectedIndexPath?.row)
        cell.configure(cellViewModel: cellModelView, isSelected: isSelected, segmentIndex: self.segIndex)
        cell.delegate = self
        return cell
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
}

