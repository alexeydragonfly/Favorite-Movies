//
//  Flow2.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 10/30/21.
//

import UIKit


class FavouriteMovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var myCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.title = "Favourites"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        myCollectionView?.addGestureRecognizer(longPressedGesture)

    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        let p = gestureRecognizer.location(in: myCollectionView)
        if let indexPath = myCollectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
        }
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.myCollectionView)

        if let indexPath = self.myCollectionView?.indexPathForItem(at: p) {
            let cell = self.myCollectionView?.cellForItem(at: indexPath)
            } else {
                print("couldn't find index path")
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = UIScreen.main.bounds.width/2.18
        layout.itemSize = CGSize(width: width, height: 300)
    
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        myCollectionView?.backgroundColor = UIColor(red: 40, green: 79, blue: 100)
        self.view.addSubview(myCollectionView!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: NSNotification.Name("didUpdate"), object: nil)
    }
    
    @objc private func didUpdate() {
        myCollectionView!.reloadData()
        print("Updated")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.favouriteMoviesCount(section: section) == 0  {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "Please add movies to your Favourites."
            label.center = self.view.center
            label.textColor = UIColor.white
            label.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
            self.view.addSubview(label)
        }
        return viewModel.favouriteMoviesCount(section: section)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        var urlString: String = ""
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        
        let moviePoster = viewModel.FMCellForRowAt(indexPath: indexPath).moviewPoster
        var moviePosterImageView : UIImageView
        let width = movieCell.contentView.layer.frame.width
        let height = movieCell.contentView.layer.frame.height
        moviePosterImageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: width, height: height))
        moviePosterImageView.layer.cornerRadius = 25
        moviePosterImageView.layer.masksToBounds = true
        movieCell.addSubview(moviePosterImageView)
        
        updateUI(poster: moviePoster)
        
        movieCell.gestureRecognizers?.removeAll()
        movieCell.tag = indexPath.row
        let directFullPreviewer = UILongPressGestureRecognizer(target: self, action: #selector(directFullPreviewLongPressAction))
        movieCell.addGestureRecognizer(directFullPreviewer)
        
        let movieTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
        movieTitleLabel.textAlignment = .center
        movieTitleLabel.text = viewModel.FMCellForRowAt(indexPath: indexPath).title
        movieTitleLabel.lineBreakMode = .byWordWrapping
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.textColor = UIColor.white
        
        let movieBottomView = UIView(frame: CGRect(x: 0, y: movieCell.contentView.frame.height - 50, width: width, height: 50))
        movieBottomView.backgroundColor = UIColor.systemBackground
        movieCell.addSubview(movieBottomView)
        movieBottomView.topAnchor.constraint(equalTo: movieCell.bottomAnchor, constant: -100).isActive = true
        movieBottomView.layer.cornerRadius = 25
        movieBottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        movieBottomView.addSubview(movieTitleLabel)
        
        movieTitleLabel.intrinsicContentSize.width
        movieTitleLabel.topAnchor.constraint(equalTo: movieBottomView.bottomAnchor, constant: -45).isActive = true
        movieTitleLabel.textColor = UIColor(red: 40/255.0, green: 79/255.0, blue: 100/255.0, alpha: 1.0)
        movieTitleLabel.textAlignment = .center
        movieTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        movieCell.addConstraint(NSLayoutConstraint(item: movieTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: movieCell, attribute: .trailing, multiplier: 1, constant: 0))
        movieCell.addConstraint(NSLayoutConstraint(item: movieTitleLabel, attribute: .leading, relatedBy: .equal, toItem: movieCell, attribute: .leading, multiplier: 1, constant: 0))
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        func updateUI(poster: String?) {
         
           guard let posterString = poster else {return}
           urlString = "https://image.tmdb.org/t/p/w300" + posterString
           
           guard let posterImageURL = URL(string: urlString) else {
               return
           }
           
            moviePosterImageView.image = nil
           
           getImageDataFrom(url: posterImageURL)
           
       }
        
       func getImageDataFrom(url: URL) {
           URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   print("DataTask error: \(error.localizedDescription)")
                   return
               }
               
               guard let data = data else {
                   print("Empty Data")
                   return
               }
               
               DispatchQueue.main.async {
                   if let image = UIImage(data: data) {
                       moviePosterImageView.image = image
                   }
               }
           }.resume()
       }
        
       return movieCell
    }
    
    @objc func directFullPreviewLongPressAction(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizer.State.began
        {
            let touchPoint = sender.location(in: myCollectionView)
            if let indexPath = myCollectionView?.indexPathForItem(at: touchPoint) {
                let nameOfMovie = viewModel.FMCellForRowAt(indexPath: indexPath).title
                viewModel.deleteFavouriteMovie(movieTitle: nameOfMovie!)
            
                let alert = UIAlertController(title: nil, message: "You have removed \(nameOfMovie!) from your Favorites.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "✔", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Favourites", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainDetails")
        self.performSegue(withIdentifier: "goToMovieDetails", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToMovieDetails"{
            let vc = segue.destination as! FavouriteMovieDetailsViewController
            let indexPath = sender as! IndexPath
            let movie = viewModel.FMCellForRowAt(indexPath: indexPath)
            vc.movie = movie
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}



