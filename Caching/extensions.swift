//
//  extensions.swift
//  BitesSeller
//
//  Created by Prajval Raval on 04/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit

let imagecache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    //FIRST CHECK FOR CACHED IMAGES:
    
    func loadimagecache(urlstring: String){
        
        if let cachedimage = imagecache.object(forKey: urlstring as AnyObject) as? UIImage{
            self.image = cachedimage
            return
        }
        
        
        
        // OTHERWISE FIRE A DOWNLOAD
        let url = URL(string: urlstring)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    imagecache.setObject(downloadedImage, forKey: urlstring as AnyObject)
                    
                    self.image = downloadedImage
                }
                
              
            }
            
            
        }).resume()
    }
}
