//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Shola Oyedele on 10/13/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: posterImageView.frame.size.height - 40)
        contentView.layer.cornerRadius = 10;
        
        let title = movie.value(forKey: "title") as! String
        titleLabel.text = title
        
        let overview = movie.value(forKey: "overview") as! String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie.value(forKey: "poster_path") as? String {
            let imageRequest = URLRequest(url: URL(string: baseUrl + posterPath)!)
            posterImageView.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.posterImageView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.posterImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    self.posterImageView.image = UIImage(named: "movietemplate")
                    // do something for the failure condition
            })
        }
        
        print(movie)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
