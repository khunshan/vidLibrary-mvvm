//
//  ViewController.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import Kingfisher

/*
protocol s1 {
    func func1() -> Void
}

extension s1 {
    func func2() -> Void {
        print("func 2")
    }
}

struct s2: s1 {
    func func1() {
        
    }
}

class s3: s1 {
    func func1() {
        
    }
}
*/

class HomeViewController: UIViewController {
    
    
    //MARK: Properties
    @IBOutlet var segControl    :UISegmentedControl!
    @IBOutlet var tableView     :UITableView!
    
    var movieModel              :MovieViewModel?
    var selectedIndexPath       :IndexPath?
    var lastIndexPath           :IndexPath?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init View Model
        movieModel = MovieViewModel()
        
        //Fetch Data from Data Center
        movieModel?.fetchServerData(callback: self.tableView.reloadData())
    }
    
    
    //MARK: Sorting
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        
        //Completion handler for Alert
        let completion: () -> Void = {
            //Reload
            self.tableView.reloadData()
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
        let segIndex = segControl.selectedSegmentIndex
        
        if (segIndex == 0) {
            movieModel?.fetchServerData(callback: self.tableView.reloadData())
        }
        else {
            movieModel?.fetchFavoriteData(callback: self.tableView.reloadData())
        }
    }
    
}

//MARK:- UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


//MARK:- UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieModel?.moviesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Configure View Model
        let cellModelView = MovieCellViewModel(movie: movieModel?.fetchMovie(at: indexPath.row))
        
        //Flag
        let isSelected = (indexPath.row == selectedIndexPath?.row)
        
        //Configure Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.configure(cellViewModel: cellModelView, isSelected: isSelected)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Print JSON
        /*
        let encoder = JSONEncoder()
        let data = try! encoder.encode(movies![indexPath.row])
        print(String(data: data, encoding: .utf8)!)
        */
        
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
extension HomeViewController: MovieCellDelegate {

    //Home Cell Delegate
    func moreButtonPressed(cell: MovieCell) {
        if let ip = tableView.indexPath(for: cell), let movie = movieModel?.fetchMovie(at: ip.row) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detail = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detail.movie = movie
            present(detail, animated: true, completion: nil)
        }
    }
}

