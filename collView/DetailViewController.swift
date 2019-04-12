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

    @IBAction func closeDetailView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleToFill ) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//}
