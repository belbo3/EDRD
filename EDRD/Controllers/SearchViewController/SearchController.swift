//
//  SearchController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit
import PromiseKit

func initialSearchController(apiService: APIService = apiService(),
                             crudService: CRUDService<Favorite> = crudService()) -> UINavigationController {
  let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
  
  let searchController = storyboard.instantiateViewController(withIdentifier: "SearchController") as! SearchController
  searchController.apiService = apiService
  searchController.crudService = crudService
  let searchControllerNavigation = UINavigationController(rootViewController: searchController)
  searchControllerNavigation.tabBarItem.title = "Search"
  searchControllerNavigation.tabBarItem.image = .icSearch
  
  return searchControllerNavigation
}

final class SearchController: UIViewController, AlertController {
  // MARK: - Properties
  
  private var mainView: SearchView {
    get { view as! SearchView }
  }
  
  private var models = [PersonModelSection]() {
    didSet {
      mainView.tableView.reloadData()
    }
  }
  
  var apiService: APIService!
  var crudService: CRUDService<Favorite>!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.tableView.dataSource = self
    
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Type something here to search"
    navigationItem.searchController = searchController
    
    mainView.tableView.register(PersonInfoCell.self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainView.tableView.reloadData()
  }
  
  // MARK: - Private methods
  
  private func setModel(items: [PersonModelDecodableItem]) {
    let items: [PersonModelItem] = items.compactMap { item in
      var bookAction: Action? = {[unowned self] in self.bookAction(link: item.linkPDF)}
      if item.linkPDF == nil {
        bookAction = nil
      }
      return .person(fullName: "\(item.lastname ?? "") \(item.firstname ?? "")",
        job: "\(item.placeOfWork ?? "")",
        position: "\(item.position ?? "")",
        comment: nil,
        id: item.id,
        bookAction: bookAction,
        markAction: {[unowned self] in self.markAction(person: item)})
    }
    models = [PersonModelSection(items: items)]
  }
  
  private func parsing(key: String) {
    let encodedTexts = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let urlString = "https://public-api.nazk.gov.ua/v1/declaration/?q=\(encodedTexts)"
    firstly {
      apiService.download(urlString)
    }.then { data -> Promise<[PersonModelDecodableItem]> in
      self.apiService.decode(data: data)
    }.done {
      self.setModel(items: $0)
    }.catch {
      self.models = []
      self.present(self.showAlert(title: $0.localizedDescription, message: nil, actions: []), animated: true, completion: nil)
    }
  }
  
  // MARK: - Actions
  
  private func bookAction(link: String?) {
    guard let link = link else { return }
    navigationController?.pushViewController(inititalPDFViewController(pdfLink: link), animated: true)
  }
  
  private func markAction(person: PersonModelDecodableItem) {
    let entity = crudService.read(modelType: .favorite, predicates: [NSPredicate(format: "id == %@", person.id)])
    if let persons = entity.value {
      if persons.isEmpty {
        present(initialCommentController(callBack: {[unowned self] comment in self.save(person: person, comment: comment) }), animated: true, completion: nil)
      } else {
        _ = persons.map {
          _ = crudService.delete(model: $0)
          mainView.tableView.reloadData()
        }
      }
    }
  }
  
  private func save(person: PersonModelDecodableItem, comment: String?) {
    let favorite = crudService.createEmptyModel(modelType: .favorite)
    favorite.firstName = person.firstname
    favorite.lastName = person.lastname
    favorite.id = person.id
    favorite.linkPDF = person.linkPDF
    favorite.placeOfWork = person.placeOfWork
    favorite.position = person.position
    favorite.comment = comment
    try? favorite.managedObjectContext?.save()
    mainView.tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models[section].items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch models[indexPath.section].items[indexPath.row] {
    case let .person(fullName, job, position, comment, id, bookAction, markAction):
      let cell = tableView.dequeueReusableCell(withIdentifier: PersonInfoCell.className, for: indexPath) as! PersonInfoCell
      cell.fullName = fullName
      cell.job = job
      cell.position = position
      cell.comment = comment
      cell.bookAction = bookAction
      cell.markAction = markAction
      let entity = crudService.read(modelType: .favorite, predicates: [NSPredicate(format: "id == %@", id)])
      if let person = entity.value {
        if person.isEmpty {
          cell.favoriteMark = false
        } else {
          cell.favoriteMark = true
        }
      }
      return cell
    }
  }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    if text != "" {
      parsing(key: text)
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    models = []
    searchBar.resignFirstResponder()
  }
}
