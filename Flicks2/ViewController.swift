//
//  ViewController.swift
//  Flicks2
//
//  Created by Rupin Bhalla on 1/24/16.
//  Copyright © 2016 Rupin Bhalla. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity


// adding for the future can be user can shake screen to switch views. 

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchViews: UISwitch!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies : [NSDictionary]?
    var filteredData : [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var switchBool = true;
    var tableViewBool = true;
    var collectionViewBool = false;
    var endPoint: String!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.alpha = 0;
        
        EZLoadingActivity.showWithDelay("Loading...", disableUI: false, seconds: 1)
        
        // switchView edit
        
        switchViews.tintColor = UIColor.grayColor()
        switchViews.onTintColor = UIColor.grayColor();
        switchViews.thumbTintColor = UIColor.blackColor()
        
        
        // navigation bar edit
        
        self.navigationItem.title = "Movies";
        if let navigationBar = navigationController?.navigationBar
        {
            // change the color
            navigationBar.barTintColor = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.0)
            //let backgroundButtonColor = UIColor.blackColor()
            //navigationBar.tintColor = backgroundButtonColor
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            shadow.shadowOffset = CGSizeMake(2, 2);
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(25),
                NSForegroundColorAttributeName : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
                NSShadowAttributeName : shadow
            ]
        }

        
        refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if(error != nil)
                {
                    print("error")
                    self.tableView.alpha = 0;
                    self.collectionView.alpha = 0;
                    self.networkLabel.alpha = 1;
                    self.networkLabel.text = "Network Error"
                }
                    
                else if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.filteredData = self.movies;
                            
                            self.tableView.reloadData();
                            self.collectionView.reloadData();
                            
                            
                            
                            
                            
                    }
                    
                }
                
        });
        task.resume()

    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        if event?.subtype == UIEventSubtype.MotionShake
        {
            if(tableViewBool)
            {
                switchViews.setOn(false, animated: true)
                
                
                tableView.alpha = 0;
                collectionView.alpha = 1;
                switchBool = false;
                tableViewBool = false;
                collectionViewBool = true;

            }
            else
            {
                switchViews.setOn(true, animated: true)
                
                collectionView.alpha = 0;
                tableView.alpha = 1;
                switchBool = true;
                tableViewBool = true;
                collectionViewBool = false;
                
            }
        }
    }

    
    /*func onRefresh(refreshControl: UIRefreshControl)
    {
        // ... Create the NSURLRequest (myRequest) ...
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let myRequest = NSURLRequest(URL: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                if(error != nil)
                {
                    print("error")
                    self.tableView.alpha = 0;
                    self.collectionView.alpha = 0;
                    self.networkLabel.alpha = 1;
                    self.networkLabel.text = "Network Error"
                }
                    
                else if let data = data {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                
                            // Reload the tableView now that there is new data
                            self.tableView.reloadData()
                
                            // Tell the refreshControl to stop spinning
                            refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }*/
    
    
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func onRefresh()
    {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = filteredData // movies
        {
            return filteredData!.count; // movies
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String
        {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            
            
            let imageURL = NSURL(string: baseUrl + posterPath)
            
            let imageRequest = NSURLRequest(URL: imageURL!)
            
            cell.moviePic.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    print("image was NOT cached, fade in")
                    cell.moviePic.alpha = 0.0
                    cell.moviePic.image = image
                    UIView.animateWithDuration(0.7, animations: { () -> Void in
                        cell.moviePic.alpha = 1.0
                    })
                } else {
                    print ("image was cached")
                    cell.moviePic.image = image
                }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
            })
            
            
            
            
            cell.title.text = title;
            cell.overview.text = overview;
        }
        
        
        //cell.moviePic.setImageWithURL(imageUrl!)
        
        
        return cell;
        
    }


    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let movies = filteredData // movies
        {
            return filteredData!.count; // movies
        }
        else
        {
            return 0;
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredData![indexPath.row] // movies
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            
            let imageURL = NSURL(string: baseUrl + posterPath)
            
            let imageRequest = NSURLRequest(URL: imageURL!)
            
            cell.moviePic.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    print("image was NOT cached, fade in")
                    cell.moviePic.alpha = 0.0
                    cell.moviePic.image = image
                    UIView.animateWithDuration(0.7, animations: { () -> Void in
                        cell.moviePic.alpha = 1.0
                    })
                } else {
                    print ("image was cached")
                    cell.moviePic.image = image
                }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
            })

        }
        
        
        
        return cell;
        
    }
    
    
    @IBAction func switchViews(sender: AnyObject)
    {
        if(!switchBool)
        {
            collectionView.alpha = 0;
            tableView.alpha = 1;
            switchBool = true;
            tableViewBool = true;
            collectionViewBool = false;
        }
        else
        {
            tableView.alpha = 0;
            collectionView.alpha = 1;
            switchBool = false;
            tableViewBool = false;
            collectionViewBool = true;
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var movie: NSDictionary!
        
        if(tableViewBool)
        {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            movie = filteredData![indexPath!.row] // movies
        }
        else
        {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            movie = filteredData![indexPath!.row] // movies
        }
        
        let detailsViewController = segue.destinationViewController as! DetailViewController
        detailsViewController.movies = movie
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String
            
            
            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil || overview.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
        
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        view.endEditing(true)
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        view.endEditing(true)
        filteredData = movies
        searchBar.text = nil
        tableView.reloadData()
        collectionView.reloadData()
        
    }
    
}

