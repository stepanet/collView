//
//  CollectionViewController.swift
//  collView
//
//  Created by Jack Sp@rroW on 14/04/2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UISearchBarDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pixelBay: PixabayJson?
    var imageInfoArray = [ImageInfo]()
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    
    private var page: Int  = { //страницы, начнем с первой
        var page = 1
        return page
    }()
    private var per_page: Int  = { //кол-во фото на странице
        var per_page = 30
        return per_page
    }()
    
    private var search: String  = { //кол-во фото на странице
        var searchText = ""
        return searchText
    }()
    
    
    lazy var searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "введите текст"
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
        return searchBar
        
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = searchBar
        //searchBar.delegate = self
        
        //searchBar.returnKeyType = UIReturnKeyType.done
        //let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pixelLoadJson(page: page, per_page: per_page, search: search)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText, "search")
        let searchText = searchText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        search = searchText
        imageInfoArray.removeAll()
        pixelLoadJson(page: page, per_page: per_page, search: search)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    
    func pixelLoadJson(page: Int, per_page: Int, search: String) {
        
        activityIndicator.startAnimating()
        
        let url = URL(string: "https://pixabay.com/api/?key=12169393-c73621fb8fde92ee029635ac1&q=\(search)&image_type=photo&pretty=true&page=\(page)&per_page=\(per_page)")
        
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
                        self.collectionView.reloadData()
                        //self.reload(collectionView: self.collectionView)
                        self.activityIndicator!.stopAnimating()
                    }
                }
                }.resume()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageInfoArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
        let url = URL(string: imageInfoArray[indexPath.row].previewURL)
        cell.image.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        
        // Configure the cell
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let sender: String = imageInfoArray[indexPath.row].webformatURL
        performSegue(withIdentifier: "detailView", sender: sender)
        
//        guard let cell = collectionView.cellForItem(at: indexPath) as? DownloadCollectionCellCollectionViewCell else { return }
//        performSegue(withIdentifier: "backToProfile", sender: cell.downloadedImageView.image)
        
    }
    
//        func reload(collectionView: UICollectionView) {
//    
//            let contentOffset = collectionView.contentOffset
//            collectionView.reloadData()
//            collectionView.layoutIfNeeded()
//            collectionView.setContentOffset(contentOffset, animated: false)
//    
//        }
    
    //подготовка данных для пересылки во вьюконтроллер
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailView" {
            let controller = segue.destination as! DetailViewController
            controller.webformatURL = sender as! String
            //controller.detailImage.downloadedFrom(url: sender as! URL)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print("searchText= \(search)")
        
        if indexPath.row == imageInfoArray.count - 6 {
            if (self.pixelBay!.totalHits / (page * per_page))  >= 1 {
                page += 1
                self.pixelLoadJson(page: page, per_page: per_page, search: search)
            }
        }
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


//
//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (view.bounds.width - 34) / 3, height: (view.bounds.width-34) / 3)
//    }
//
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
