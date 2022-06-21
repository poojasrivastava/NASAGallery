//
//  NSAGalleryResponse.swift
//  NASAGallery
//
//  Created by Pooja Srivastava on 20/06/22.
//

import Foundation

struct NSAGalleryResponse:Codable,Hashable {
    let response : [String: String]

    init(data:[String: String]){
       response = data
    }

}
import Foundation
enum networkingError : Error{
    case badNetworkigStuff

}
