//
//  Movie.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 1/19/22.
//

import Foundation

class MoviesData: Codable {
    let movies: [Movie]
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

class Movie: NSObject, Codable {
    var isFavoutire: Bool? = false
    let title: String?
    let year: String?
    let rate: Double?
    let moviewPoster: String?
    let overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview
        case year = "release_date"
        case rate = "vote_average"
        case moviewPoster = "poster_path"
    }
}
