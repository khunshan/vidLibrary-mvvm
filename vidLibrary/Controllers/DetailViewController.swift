//
//  DetailViewController.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie!.headline ?? "NA")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
