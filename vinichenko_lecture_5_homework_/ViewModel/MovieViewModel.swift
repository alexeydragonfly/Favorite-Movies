//
//  MoviesViewModel.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 1/19/22.
//

import Foundation

public class MovieViewModel {
    
    private var apiService = ApiService()
    private var popularMovies = [Movie]()
    private var favouriteMovies = [Movie]()
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        apiService.getPopularMoviesData { [weak self] (result) in
        switch result {
            case .success(let listOf):
                self?.popularMovies = listOf.movies
                completion()
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func findFavouriteMovies() {
        for movie in popularMovies {
            if movie.isFavoutire == true {
                favouriteMovies.append(movie)
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if popularMovies.count != 0 {
            return popularMovies.count
        }
        return 0
    }
    
    func favouriteMoviesCount(section: Int) -> Int {
        if favouriteMovies.count != 0 {
            return favouriteMovies.count
        }
        return 0
    }
    
    func addFavouriteMovie(indexPath: IndexPath) -> Int {
        favouriteMovies.append(popularMovies[indexPath.row])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdate"), object: nil)
        return 0
    }
    
    
    func deleteFavouriteMovie(movieTitle: String) -> Int {
        let movieToRemove = movieTitle
        print(movieTitle)
        favouriteMovies.remove(where: { (obj) -> Bool in
            return obj.title == movieToRemove
        })
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdate"), object: nil)
        print("После удаления любимые фильмы: ")
        dump(favouriteMovies)
        return 0
    }
    
    
    
    
    func FMCellForRowAt (indexPath: IndexPath) -> Movie {
        return favouriteMovies[indexPath.row]
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return popularMovies[indexPath.row]
    }
}

extension Array where Element: Equatable {

    @discardableResult mutating func remove(object: Element) -> Bool {
        if let index = index(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }

    @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.index(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }

}

public var viewModel = MovieViewModel()
