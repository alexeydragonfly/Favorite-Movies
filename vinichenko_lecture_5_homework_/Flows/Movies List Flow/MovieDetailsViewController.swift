//
//  MovieDetailsViewController.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 1/21/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieDetailsView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    
    var movie: Movie!
    var urlString: String = ""
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        moviePosterImageView.layer.cornerRadius = 25
        moviePosterImageView.layer.masksToBounds = true
        movieDetailsView.clipsToBounds = true
        movieDetailsView.layer.cornerRadius = 25
        movieDetailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        setupMoviePoster(poster: movie.moviewPoster)
        
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = String(format: "%.1f", movie.rate as! CVarArg)
        movieDateLabel.text = movie.year
        movieDescriptionLabel.text = movie.overview
    }
    
    private func setupMoviePoster(poster: String?) {
     
       guard let posterString = poster else {return}
       urlString = "https://image.tmdb.org/t/p/w300" + posterString
       
       guard let posterImageURL = URL(string: urlString) else {
           return
       }
       self.moviePosterImageView.image = nil
       getImageDataFrom(url: posterImageURL)
       
   }
    
    private func getImageDataFrom(url: URL) {
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
                   self.moviePosterImageView.image = image
               }
           }
       }.resume()
   }
}


