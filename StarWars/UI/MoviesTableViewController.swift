
import UIKit

private let reuseIdentifier = "MoviePreviewCellIdentifier"

class PeopleTableViewController: UITableViewController {
    
    private let tmdb = StarWarsSearch()
    private var searchName: String = "" // current search name, to match with response from StarWars
    private var movies: [Person?] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // logo
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "logo")
        navigationItem.titleView = logo
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.tintColor = .tmdbBlue
        
        // remove separtor for empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        
        // prefetching
        tableView.prefetchDataSource = self
    }
    
}

// MARK: - StarWars Data source
private extension PeopleTableViewController {
    
    func movie(for indexPath: IndexPath) -> Person? {
        return movies[indexPath.row]
    }
    
    func search(_ name: String, index: Int) {
        self.searchName = name
        
        // Clean up the result if search name is empty
        if (name.isEmpty) {
            self.movies = []
            self.tableView?.reloadData()
            return
        }
        
        tmdb.search(for: name, index: index) {[weak self] response in
            switch response {
            case .error(let error):
                // TODO: display error to user
                print("Error: '\(error)'.")
            case .data(let data):
                print("\(data.people.count) matching '\(data.name)'.")
                
                // response may come when we don't need it already
                if (data.name == self?.searchName) {
                    self?.movies = data.people
                    self?.tableView?.reloadData()
                }
            }
        }
    }
    
}

// MARK: - Prefetching Model
private extension PeopleTableViewController {
    
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return movies[indexPath.row] == nil
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
    
}

// MARK: - Table view data source prefetching
extension PeopleTableViewController: UITableViewDataSourcePrefetching {
    
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print(indexPaths)
    if indexPaths.contains(where: isLoadingCell) {
        for ip in indexPaths {
            search(searchName, index: ip.row)
        }
        
    }
  }
    
}

// MARK: - UISearchResultsUpdating
extension PeopleTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        search(text, index: 0)
    }
    
}

// MARK: - Table view data source
extension PeopleTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PersonPreviewCell
        
        if isLoadingCell(for: indexPath) {
            return cell
        }
        
        let m = movie(for: indexPath)!
        
        cell.name.text = m.name ?? ""
//       
        
        return cell
    }
        
}

// MARK: - Table view delegate
extension PeopleTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? MovieDetailsViewController {
            vc.movie = movie(for: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
