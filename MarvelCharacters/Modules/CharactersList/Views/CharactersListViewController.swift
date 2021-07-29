//
//  CharactersListViewController.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharactersListViewController: UIViewController {

    var presenter: CharactersListViewToPresenterProtocol?

    @IBOutlet var apiUsageMessageLabel: UILabel!
    @IBOutlet var apiUsageMessageView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var infoMessageLabel: UILabel!

    var cellIdentifier = "CharacterListItemCell"
    var maxIndexPath: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.searchBar.delegate = self
        //VIEW SETUP
        configureNavigationBar()
        self.loader.startAnimating()
        presenter?.viewDidLoad()
    }

}

/// MARK: Navigartion Bar
extension CharactersListViewController {

    func configureNavigationBar() {
        navigationItem.title = "Marvel Characters"
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.edgesForExtendedLayout = []
    }
}

/// MARK: Presenter -> ViewController
extension CharactersListViewController: CharactersListPresenterToViewProtocol {
    func onGetCharacterListSuccess(scrollToTop: Bool) {
        self.mainTableView.reloadData()
        if scrollToTop {
            self.mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.maxIndexPath = 0
        }
        if let apiMessage = self.presenter?.getApiUsageMesage(), apiMessage.count > 0 {
            self.apiUsageMessageLabel.text = apiMessage
            self.apiUsageMessageView.isHidden = false
        }
        self.searchBar.isHidden = false
        self.mainTableView.isHidden = false
        self.loader.stopAnimating()
    }

    func onGetCharacterListFailure(errorMessage: String) {
        self.loader.stopAnimating()
        self.apiUsageMessageView.isHidden = true
        self.mainTableView.isHidden = true
        self.infoMessageLabel.text = errorMessage
        self.infoMessageLabel.isHidden = false
    }

    func showNoResultsView() {
        self.apiUsageMessageView.isHidden = true
        self.mainTableView.isHidden = true
        self.infoMessageLabel.text = "No characters found"
        self.infoMessageLabel.isHidden = false
        self.loader.stopAnimating()
    }

    func showLoader() {
        self.infoMessageLabel.isHidden = true
        self.mainTableView.isHidden = true
        self.apiUsageMessageView.isHidden = true
        self.loader.isHidden = false
        self.loader.startAnimating()
    }

}

/// MARK: TableView
extension CharactersListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nRows = self.presenter?.numberOfRows() ?? 0
        return nRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as!CharacterListItemCell
        if let character = self.presenter?.characterAtIndex(index: indexPath) {
            cell.configureCell(character: character)
        }

        if indexPath.row > self.maxIndexPath {
            self.maxIndexPath = indexPath.row
            self.presenter?.updateMaxIndex(index: indexPath.row)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.characterSelectedAtIndex(index: indexPath)
    }

}

/// MARK: SearchBar
extension CharactersListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.searchBarTextChanged(with: searchText)
    }
}
