//
//  SearchViewModel.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import Foundation

class SearchViewModel {
    var item: Movie?
    var movieItems = [MovieResult]()
    var text = ""
    var successCallback: (()->())?
    var errorCallback: ((String)->())?
    var showAlertClosure: ((String, String) -> Void)?
    
    func getItems() {
        HomeManager.shared.getSearchItems(text: text, page: item?.page ?? 0 + 1) { [weak self] movie, error in
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.item = movie
                if let movieItems = movie?.results, !movieItems.isEmpty {
                    self?.movieItems.append(contentsOf: movieItems)
                }
                self?.successCallback?()
            }
        }
    }
    
    func pagination(index: Int) {
        if let item = item {
            if (item.page ?? 0 <= item.totalPages ?? 0) && index == (movieItems.count - 1) {
                getItems()
            }
        }
    }
    
    func search(text: String) {
        resetDatas()
        self.text = text
        getItems()
    }
    
    func resetDatas() {
        text = ""
        item = nil
        movieItems.removeAll()
    }
    
    func someOperation() {
        let errorMessage = "An error occurred"
        let errorTitle = "Error"
        showAlertClosure?(errorTitle, errorMessage)
    }
}
