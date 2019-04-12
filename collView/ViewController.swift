//
//  ViewController.swift
//  collView
//
//  Created by Jack Sp@rroW on 11/04/2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//
//https://pixabay.com/api/?key=12169393-c73621fb8fde92ee029635ac1&q=image_type=photo&pretty=true&page=1&per_page=15

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
   
        let url = URL(string: imageInfoArray[indexPath.row].previewURL)
        cell.image.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pixelBay: PixabayJson?
    var imageInfoArray = [ImageInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        collectionView.isPagingEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pixelLoadJson()
    }
    
    
    func pixelLoadJson() {
        let url = URL(string: "https://pixabay.com/api/?key=12169393-c73621fb8fde92ee029635ac1&q=&image_type=photo&pretty=true&page=1&per_page=200")
        
        //let url = URL(string: "http://localhost/5.json")
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.pixelBay = try JSONDecoder().decode(PixabayJson.self, from: data!)
                        self.imageInfoArray = self.pixelBay!.hits
                        
                    } catch {
                        print("pixelBay load error",error.localizedDescription)
                    }
                    print(self.imageInfoArray.count)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
                }.resume()
        }
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleToFill ) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
}
