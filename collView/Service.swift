//
//  Service.swift
//  collView
//
//  Created by Jack Sp@rroW on 12/04/2019.
//  Copyright © 2019 Jack Sp@rroW. All rights reserved.
//

import Foundation

protocol IModel {
    var pixelBay: PixabayJson? { get set }
    var imageInfoArray: [ImageInfo]? {get set}
}


class Service: IModel {
    
    var imageInfoArray: [ImageInfo]?
    var pixelBay: PixabayJson?

    func pixelLoadJson() {
        let url = URL(string: "https://pixabay.com/api/?key=12169393-c73621fb8fde92ee029635ac1&q=&image_type=photo&pretty=true&page=1&per_page=18")

        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.pixelBay = try JSONDecoder().decode(PixabayJson.self, from: data!)
                        
                        self.imageInfoArray = self.pixelBay!.hits

                    } catch {
                        print("pixelBay load error",error.localizedDescription)
                    }
                    print(self.imageInfoArray!.count)
                }
                }.resume()
        }
    }
}
