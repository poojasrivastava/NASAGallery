//
//  ViewController.swift
//  NASA_API
//
//  Created by Missy Allan on 11/3/16.
//  Copyright © 2016 Missy Allan. All rights reserved.
//

import UIKit
import Intents
import Combine
import youtube_ios_player_helper
import AVKit

class ViewController: UIViewController {

  @IBOutlet weak var staticTitle: UILabel!

    @IBOutlet weak var sourceLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var imageTitle: UILabel!

    @IBOutlet weak var imageExplanation: UITextView!

    @IBOutlet weak var picOfTheDay: UIImageView!

    @IBOutlet weak var moreSpace: UIButton!

   @IBOutlet var playerView:  YTPlayerView!



    override func viewDidLoad() {
        super.viewDidLoad()
       self.getNSAGalleryData()

    }


    func getNSAGalleryData(){
        NSAAPI.getNSAGalleryData{(result) in
            switch result{

            case .success(let response):
                DispatchQueue.main.async {
                    self.dateLabel.text =  response.date
                    self.imageExplanation.text =  response.explanation
                    self.imageTitle.text =  response.title
                    self.handleMediaType(mediaType: response.mediaType ?? " ", mediaUrl: response.url ?? " ")
                }

               case.failure(let error):
                debugPrint(error.localizedDescription)

            }

        }

    }
    func handleMediaType(mediaType:String,mediaUrl:String){
        if mediaType == "image"{
            self.picOfTheDay.isHidden = false
            self.playerView.isHidden = true
            downloadImage(imageUrl: mediaUrl)

        }
        else if mediaType == "video"{
            self.picOfTheDay.isHidden = true
            self.playerView.isHidden = false
            self.playYouTubeVideo(youtubeURl:mediaUrl)


        }
    }

    func playYouTubeVideo(youtubeURl:String) {
        let youTubeID = youtubeURl.youtubeID ?? ""
        debugPrint("YoutubeId is: \(youTubeID)")
        playerView.load(withVideoId: youTubeID)
        playerView.playVideo()
    }
    func downloadImage(imageUrl:String) {
        
        NSAAPI.downloadImage(at: imageUrl, completion: { (success, image) in
            if success == true {
                DispatchQueue.main.async {
                    self.picOfTheDay.image = image
                }
            }
            else {
                debugPrint("Error getting image")
            }
        })
    }

}

extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"

        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)

        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }

        return (self as NSString).substring(with: result.range)
    }

}
