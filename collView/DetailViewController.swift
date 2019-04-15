//
//  DetailViewController.swift
//  collView
//
//  Created by Jack Sp@rroW on 13/04/2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var webformatURL: String = {
        var str = ""
        return str
    }()
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(webformatURL)
        detailImage.downloadedFrom(url: URL(string: webformatURL)!, contentMode: .scaleAspectFit)
        
    }
}
