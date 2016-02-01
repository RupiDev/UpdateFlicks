//
//  DetailViewController.swift
//  Flicks2
//
//  Created by Rupin Bhalla on 1/25/16.
//  Copyright © 2016 Rupin Bhalla. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var posterPic: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movies: NSDictionary!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movie Details";
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movies["title"] as! String!
        titleLabel.text = title;
        
        let overview = movies["overview"] as! String!
        overviewLabel.text = overview;
        
        overviewLabel.sizeToFit();
        
        let baseUrlHighRes = "http://image.tmdb.org/t/p/w500"
        let baseUrlLowRes = "https://image.tmdb.org/t/p/w45"

        
        if let posterPath = movies["poster_path"] as? String
        {
         
            let smallImageUrl = baseUrlLowRes + posterPath;
            let bigImageUrl = baseUrlHighRes + posterPath;
            
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: bigImageUrl)!)
            
            let defaultImageUrl = NSURL(string: baseUrlHighRes + posterPath)

            
            self.posterPic.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterPic.alpha = 0.0
                    self.posterPic.image = smallImage;
                    
                    UIView.animateWithDuration(0.7, animations: { () -> Void in
                        
                        self.posterPic.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            self.posterPic.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.posterPic.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    
                                    self.posterPic.setImageWithURL(defaultImageUrl!);
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    
                    self.posterPic.setImageWithURL(defaultImageUrl!);
                    // do something for the failure condition
                    // possibly try to get the large image
            })
            
            
            
            //let imageUrl = NSURL(string: baseUrlHighRes + posterPath)
            //posterPic.setImageWithURL(imageUrl!);
            
            
            
            
            
            
        }
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
