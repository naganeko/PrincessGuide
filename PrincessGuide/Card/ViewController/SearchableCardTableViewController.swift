//
//  SearchableCardTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/28.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class SearchableCardTableViewController: CardTableViewController {
    
    var filteredCards = [Card]()

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Name"
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        return searchController
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navigationController?.navigationBar.barStyle == .default {
            return .default
        } else {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.searchController.searchBar.tintColor = theme.color.tint
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchController.isActive {
        case true:
            return filteredCards.count
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchController.isActive {
        case true:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.description(), for: indexPath) as! CardTableViewCell
            cell.configure(for: filteredCards[indexPath.row])
            return cell
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchController.isActive {
        case true:
            let card = filteredCards[indexPath.row]
            let vc = CDTabViewController(card: card)
            print("card id: \(card.base.unitId)")
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

}

extension SearchableCardTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredCards = cards.filter { $0.base.unitName.contains(searchText) || $0.actualUnit.unitName.contains(searchText) }
        
        tableView.reloadData()
    }
    
}
