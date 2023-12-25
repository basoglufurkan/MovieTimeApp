//
//  SearchViewController.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    fileprivate func configureUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieTableViewCell.id, bundle: nil), forCellReuseIdentifier: "movieCell")
        arrowIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowIconTap)))
        arrowIcon.isUserInteractionEnabled = true
    }
    
    fileprivate func configureViewModel() {
        viewModel.errorCallback = { [weak self] errorMessage in
            guard let self = self else { return }
            viewModel.showAlertClosure = { [weak self] title, message in
                self?.showAlert(title: "Error", message: errorMessage)
            }
        }
        viewModel.successCallback = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc fileprivate func arrowIconTap() {
        HomeViewController.present(from: self)
    }
    
    @IBAction func searchTextFieldAction(_ sender: Any) {
        if !(searchTextField.text?.isEmpty ?? false) {
            viewModel.search(text: searchTextField.text ?? "")
            tableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    static func present(from: UIViewController) {
        let vc = SearchViewController.loadFromNib()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        from.present(vc, animated: false)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell",for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.configure(viewModel.movieItems[indexPath.item]) //passing data to the method.
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? false {
            viewModel.resetDatas()
            tableView.reloadData()
        }
        textField.resignFirstResponder()
        return true
    }
}

