//
//  MyTableViewCell.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 11/15/21.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    
    
    private var urlString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellWithValuesOf(_ movie:Movie) {
        updateUI(title: movie.title, releaseDate: movie.year, rating: movie.rate, overview: movie.overview, poster: movie.moviewPoster)
    }
    
    private func updateUI(title: String?, releaseDate: String?, rating: Double?, overview: String?, poster: String? ) {
        self.titleLabel.text = title
        self.subtitleLabel.text = convertDateFormater(releaseDate)
        self.movieOverviewLabel.text = overview
        self.movieRateLabel.text = String(format: "%.1f", rating as! CVarArg)
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            return
        }
        
        self.imageCell.image = nil
        
        getImageDataFrom(url: posterImageURL)
        
    }
    
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.imageCell.image = image
                }
            }
        }.resume()
    }
    
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
    
}
