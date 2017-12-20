//
//  ViewController.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var movies: [Movie]?
    
    
    //View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch Data from Data Center
        fetchData()
    }

    //Data Center 
    func fetchData() {
        DataCenter.fetchMoviesData { (moviesArray:[Movie]?, error:Error?) in
            print("response fetched")
            self.movies = moviesArray
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let movie = movies![indexPath.row] as Movie
        
        cell.titleLabel.text = "Title: " + (movie.headline ?? "--")
        cell.subtitleLabel.text = "Year of release: " + (movie.year ?? "--")

        return cell
    }
}

