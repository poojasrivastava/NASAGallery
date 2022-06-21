//
//  NSAAPI.swift
//  NASAGallery
//
//  Created by Pooja Srivastava on 20/06/22.
//

import Foundation
import UIKit

class NSAAPI {

    static  func getNSAGalleryData(completion:@escaping (Result<NSAData,Error>)->Void){

        guard let  url  = URL(string:"https://api.nasa.gov/planetary/apod?api_key=kDPttO02u1EhjigW2tpFV6cvUwnI5Cg3CzczFAKe") else {
            debugPrint("Invalid URL!"); return

        }
        URLSession.shared.dataTask(with: url){(data,response,error) in
            if let error = error{
                completion(.failure(error.localizedDescription as! Error))
                return
            }

            do{
                let response = try! JSONDecoder().decode(NSAData.self, from: data!)
                debugPrint("response----",response)

                completion(.success(response))

            } catch let jsonError{
                completion(.failure(jsonError.localizedDescription as! Error))
            }
        }.resume()

    }
    static func downloadImage(at urlString: String, completion: @escaping (Bool, UIImage?) -> ()) {

         let url = URL(string: urlString)
         guard let unwrappedURL = url else {return}

         let request = URLRequest(url: unwrappedURL)

         let session = URLSession.shared

         let task = session.dataTask(with: request) { data, response, error in

             guard let data = data, let image = UIImage(data: data) else { completion(false, nil); return }

            completion(true, image)

         }
         task.resume()
     }
}
