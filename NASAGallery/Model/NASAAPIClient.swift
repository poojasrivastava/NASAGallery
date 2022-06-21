//
//  NASAAPIClient.swift
//  NASAGallery
//
//  Created by Pooja Srivastava on 17/06/22.
//

import Foundation
import UIKit

let youtubeRegex = try! NSRegularExpression(pattern: #"://.*youtube\.com/embed/([^/?#]+)"#)
let vimeoRegex = try! NSRegularExpression(pattern: #"://.*vimeo\.com/video/([^/?#]+)"#)

public class NSAData :Codable {
    private let rawEntry: NSAGalleryEntry
    public var date: String? { rawEntry.date }
    public var title: String? { rawEntry.title }
    public var copyright: String? { rawEntry.copyright }
    public var explanation: String? { rawEntry.explanation }
    public var mediaType: String? { rawEntry.mediaType}
    public var url: String? { rawEntry.url}

   // public let asset: Asset

    public required init(from decoder: Decoder) throws {
      rawEntry = try NSAGalleryEntry(from: decoder)

//      let mediaURL: URL
//      if let hdurl = rawEntry.hdurl {
//        mediaURL = hdurl
//      } else if let url = rawEntry.url {
//        mediaURL = url
//      } else {
//        throw APODErrors.missingURL
//      }
//
//      asset = Asset(mediaType: rawEntry.mediaType, url: mediaURL)
    }

    public func encode(to encoder: Encoder) throws {
      try rawEntry.encode(to: encoder)
    }

//    private init(rawEntry: NSAGalleryEntry, asset: Asset, dataFilename: String, imageFilename: String) {
//      self.rawEntry = rawEntry
//      self.asset = asset
//
//    }

}

struct NSAGalleryEntry: Codable {
  var date: String?
  var hdurl: URL?
  var url: String?
  var title: String?
  var copyright: String?
  var explanation: String?
  var mediaType: String

  enum CodingKeys: String, CodingKey {
    case copyright
    case date
    case explanation
    case hdurl
    case url
    case mediaType = "media_type"
    case title
  }
}
public enum Asset {
  case image(URL)
  case vimeoVideo(id: String, url: URL)
  case youtubeVideo(id: String, url: URL)
  case unknown(URL)

  init(mediaType: String, url: URL) {
    switch mediaType {
    case "image":
      self = .image(url)

    case "video":
      let str = url.absoluteString
      if let match = youtubeRegex.firstMatch(in: str, range: NSRange(str.startIndex..<str.endIndex, in: str)),
         let range = Range(match.range(at: 1), in: str) {
        self = .youtubeVideo(id: String(str[range]), url: url)
      } else if
        let match = vimeoRegex.firstMatch(in: str, range: NSRange(str.startIndex..<str.endIndex, in: str)),
        let range = Range(match.range(at: 1), in: str) {
        self = .vimeoVideo(id: String(str[range]), url: url)
      } else {
        self = .unknown(url)
      }

    default:
      self = .unknown(url)
    }
  }
     func downloadImage(at url: URL, completion: @escaping (Bool, Data?) -> ()) {

        // let urlString = "http://apod.nasa.gov/apod/image/1611/NGC253hagerC1024.JPG"
         //let url = URL(string: urlString)
       // guard let unwrappedURL = url else {return}

         let request = URLRequest(url: url)

         let session = URLSession.shared

         let task = session.dataTask(with: request) { data, response, error in

             guard let data = data
             else { completion(false, nil); return }

            completion(true, data)

         }
         task.resume()
     }

}
