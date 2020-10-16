
import UIKit

private let reuseIdentifier = "CharacterPreviewCellIdentifier"

class CharactersTableViewController: UITableViewController {
    
    private let data = CharactersSearch()
    
    /// current search name, to match with response from search API which are async
    private var searchName: String = ""
    /// search name for which current data is already displayed in tableView
    private var displayedSearchName: String = ""
    private var characters: [Character?] = []
    
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
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.tintColor = .darkBackground
        
        // remove separtor for empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        
        // prefetching
        tableView.prefetchDataSource = self
        
        search(searchName, index: 0)
    }
    
}

// MARK: - UISearchResultsUpdating
extension CharactersTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        search(text, index: 0)
    }
    
}

// MARK: - Star Wars Characters Data source
private extension CharactersTableViewController {
    
    func character(for indexPath: IndexPath) -> Character? {
        return characters[indexPath.row]
    }
    
    func isCharacterLoading(for indexPath: IndexPath) -> Bool {
        return characters[indexPath.row] == nil
    }
    
    func search(_ name: String, index: Int) {
        self.searchName = name
        
        data.search(for: name, index: index) {[weak self] response in
            switch response {
            case .error(let error):
                // TODO: display error to user
                print("Error: '\(error)'.")
            case .data(let data):
                // response may come when another search string is active already
                if (data.name == self?.searchName) {
                    self?.characters = data.items
                    
                    // if just a new page
                    if data.name == self?.displayedSearchName {
                        if let indexPaths = data.indexes?.map({IndexPath(row: $0, section: 0)}),
                           let indexPathsToReload = self?.visibleIndexPathsToReload(intersecting: indexPaths) {
                            self?.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
                            return
                        }
                    }
                    
                    // if new data to display
                    self?.displayedSearchName = data.name
                    self?.tableView?.reloadData()
                }
            }
        }
    }
    
}

// MARK: - Prefetching Model
private extension CharactersTableViewController {
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
}

// MARK: - Table view data source prefetching
extension CharactersTableViewController: UITableViewDataSourcePrefetching {
    
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isCharacterLoading) {
        for ip in indexPaths {
            search(searchName, index: ip.row)
        }
    }
  }
    
}

// MARK: - Table view data source
extension CharactersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CharacterPreviewCell
        
        if isCharacterLoading(for: indexPath) {
            cell.configure(with: .none)
        } else {
            let m = character(for: indexPath)!
            cell.configure(with: m)
        }
        
        return cell
    }
        
}

// MARK: - Table view delegate
extension CharactersTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let character = character(for: indexPath),
           let vc = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? CharacterDetailsViewController {
            vc.character = character
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
