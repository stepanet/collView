//
//  ViewController.swift
//  collView
//
//  Created by Jack Sp@rroW on 11/04/2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pixelBay: PixabayJson?
    var imageInfoArray = [ImageInfo]()
    var page: Int  = { //страницы, начнем с первой
        var page = 1
        return page
    }()
    var per_page: Int  = { //кол-во фото на странице
        var per_page = 20
        return per_page
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        
        self.collectionView.performBatchUpdates(nil, completion: {
            (result) in
            // ready
            print("collection view load")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pixelLoadJson(page: page, per_page: per_page)
    }
    
    
    func pixelLoadJson(page: Int, per_page: Int) {
        
        activityIndicator.startAnimating()
        
        let url = URL(string: "https://pixabay.com/api/?key=12169393-c73621fb8fde92ee029635ac1&q=&image_type=photo&pretty=true&page=\(page)&per_page=\(per_page)")

        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.pixelBay = try JSONDecoder().decode(PixabayJson.self, from: data!)
                        self.imageInfoArray += self.pixelBay!.hits
                        
                    } catch {
                        print("pixelBay load error",error.localizedDescription)
                    }
                    print(self.imageInfoArray.count, "=imageInfoArray.count")
                    DispatchQueue.main.async {
                        //self.collectionView.reloadData()
                        self.reload(collectionView: self.collectionView)
                        self.activityIndicator!.stopAnimating()
                    }
                }
            }.resume()
        }
    }
    
    func reload(collectionView: UICollectionView) {
        
        let contentOffset = collectionView.contentOffset
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(contentOffset, animated: false)
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let url = URL(string: imageInfoArray[indexPath.row].previewURL)
        //cell.image.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        
        let sender: String = imageInfoArray[indexPath.row].webformatURL
        //performSegue(withIdentifier: "detailView", sender: sender)
    }
    
    //подготовка данных для пересылки во вьюконтроллер
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailView" {
            let controller = segue.destination as! DetailViewController
            controller.webformatURL = sender as! String
            //controller.detailImage.downloadedFrom(url: sender as! URL)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
                if indexPath.row == imageInfoArray.count - 6 {
                    if (self.pixelBay!.totalHits / (page * per_page))  >= 1 {
                        page += 1
                        //self.pixelLoadJson(page: page, per_page: per_page)
                    }
                }
    }
    
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (view.bounds.width - 34) / 3, height: (view.bounds.width-34) / 3)
//    }

//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 7.0
//    }
//}

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
