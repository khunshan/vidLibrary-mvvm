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
    
    @IBOutlet var segControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var movies                 :[Movie]?
    var selectedIndexPath      :IndexPath?
    var lastIndexPath          :IndexPath?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch Data from Data Center
        fetchServerData(callback: self.tableView.reloadData())
    }
    
    //MARK: Data Center
    func fetchServerData(callback: @escaping @autoclosure () -> Void) {
        DataCenter.fetchMoviesData { (moviesArray:[Movie]?, error:Error?) in
            print("response fetched")
            self.movies = moviesArray
            callback()
        }
    }
    
    func fetchFavoriteData(callback: @escaping @autoclosure () -> Void) {

        self.movies = nil
        callback()
    }
    
    //MARK: Sort
    func sortMovies(sortBy: (Movie, Movie) -> Bool) {

        let temp = movies?.sorted(by: sortBy)
        
        movies = temp
        
        //Collapse all cells
        selectedIndexPath = nil
        lastIndexPath = nil
        
        //Reload
        tableView.reloadData()
    }
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Title", style: .default) { (action:UIAlertAction) in
            self.sortMovies(sortBy: { ($0.headline ?? "") < ($1.headline ?? "") })
        }
        
        let action2 = UIAlertAction(title: "Year", style: .default) { (action:UIAlertAction) in
            self.sortMovies(sortBy: { ($0.year ?? "") < ($1.year ?? "") })
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .destructive, handler:nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Segmented Control Change
    @IBAction func segControlValueChanged(_ sender: Any) {
        let segIndex = segControl.selectedSegmentIndex
        
        if (segIndex == 0) {
            fetchServerData(callback: self.tableView.reloadData())
        } else {
            fetchFavoriteData(callback: self.tableView.reloadData())
        }
    }
    
}


extension HomeViewController: UITableViewDelegate { //MARK : - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension HomeViewController: UITableViewDataSource { //MARK : - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let movie = movies![indexPath.row] as Movie
        
        cell.delegate = self

        //Populate movie data
        cell.titleLabel.text     = "Title: " + (movie.headline ?? "--")
        cell.subtitleLabel.text  = "Year of release: " + (movie.year ?? "--")
        
        if let imageUrlString = movie.keyArtImages?[0].url {
            cell.leftImageView.kf.setImage(with: URL(string: imageUrlString))
        } else {
            cell.leftImageView.image = UIImage(named: "noImage")
        }
        
        //Is Selected Cell Check
        let isSelected = (indexPath.row == selectedIndexPath?.row)
        cell.descriptionLabel.numberOfLines = isSelected ? 0 : 1
        cell.descriptionLabel.text = isSelected ? (movie.synopsis ?? "No Details") : ""
        
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
            } else {
                ipToReload.append(lastIndexPath!)
            }
        }
        
        tableView.reloadRows(at: ipToReload, with: UITableViewRowAnimation.automatic)
        lastIndexPath = selectedIndexPath
    }
}


extension HomeViewController: HomeCellDelegate { //MARK: - HomeCellDelegate

    //Home Cell Delegate
    func moreButtonPressed(cell: HomeCell) {
        if let ip = tableView.indexPath(for: cell), let movie = movies?[ip.row] {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detail = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detail.movie = movie
            present(detail, animated: true, completion: nil)
        }
    }
}

