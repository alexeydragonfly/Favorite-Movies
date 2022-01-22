//
//  Main.swift
//  vinichenko_lecture_5_homework_
//
//  Created by Alexey on 11/12/21.
//

import UIKit
import Foundation

class MoviesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let idCell = "myCell"
    
    var apiService = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPopularMoviesData()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.title = "Movies"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let nameOfMovie = viewModel.cellForRowAt(indexPath: indexPath).title
                viewModel.cellForRowAt(indexPath: indexPath).isFavoutire = viewModel.cellForRowAt(indexPath: indexPath).isFavoutire == true ? false : true
                dump(viewModel.cellForRowAt(indexPath: indexPath))
                
                if viewModel.cellForRowAt(indexPath: indexPath).isFavoutire == true {
                    viewModel.addFavouriteMovie(indexPath: indexPath)
                    let alert = UIAlertController(title: nil, message: "You have added \(nameOfMovie!) to your Favorites.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "✔", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    viewModel.deleteFavouriteMovie(movieTitle: nameOfMovie!)
                    let alert = UIAlertController(title: nil, message: "You have removed \(nameOfMovie!) from your Favorites.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "✔", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func loadPopularMoviesData() {
            viewModel.fetchPopularMoviesData { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }
}


extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! MyTableViewCell
        cell.imageCell.layer.borderWidth = 1
        cell.imageCell.layer.masksToBounds = false
        cell.imageCell.layer.borderColor = UIColor.black.cgColor
        cell.imageCell.clipsToBounds = true
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MoviesList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainDetails")
        self.performSegue(withIdentifier: "goToMovieDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToMovieDetails"{
            let vc = segue.destination as! MovieDetailsViewController
            let indexPath = sender as! IndexPath
            let movie = viewModel.cellForRowAt(indexPath: indexPath)
            vc.movie = movie
        }
    }
  
}
