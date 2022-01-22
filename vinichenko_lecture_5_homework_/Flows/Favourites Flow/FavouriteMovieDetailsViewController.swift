//
//  FavouriteMovieDetailsViewController.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 1/22/22.
//

import UIKit

class FavouriteMovieDetailsViewController: UIViewController {
    var movie: Movie!
    var urlString: String = ""
    
    let moviePosterImageView: UIImageView = {
        let theImageView = UIImageView()
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.layer.masksToBounds = true
        theImageView.layer.cornerRadius = 25
        return theImageView
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.textAlignment = .center
        return label
    }()
    
    let movieOverviewLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(moviePosterImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(movieOverviewLabel)
        moviePosterImageViewConstraints()
        movieTitleLabelConstraints()
        movieOverviewLabelConstraints()
        setupUI()
    }
    
    private func setupUI() {
        setupMoviePoster(poster: movie.moviewPoster)
        movieOverviewLabel.text = movie.overview
        movieTitleLabel.text = movie.title
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
    
    private func moviePosterImageViewConstraints() {
        moviePosterImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        moviePosterImageView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        moviePosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moviePosterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
    }
    
    private func movieTitleLabelConstraints() {
        movieTitleLabel.intrinsicContentSize.width
        movieTitleLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 5).isActive = true
        movieTitleLabel.textColor = UIColor.black
        movieTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        
        view.addConstraint(NSLayoutConstraint(item: movieTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: movieTitleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.lineBreakMode = .byWordWrapping
        movieTitleLabel.numberOfLines = 0
    }
    
    private func movieOverviewLabelConstraints() {
        movieOverviewLabel.intrinsicContentSize.width
        movieOverviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 30).isActive = true
        movieOverviewLabel.textColor = UIColor.black
        movieOverviewLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        
        view.addConstraint(NSLayoutConstraint(item: movieOverviewLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: movieOverviewLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        movieOverviewLabel.lineBreakMode = .byWordWrapping
        movieOverviewLabel.numberOfLines = 0
    }
    
}
