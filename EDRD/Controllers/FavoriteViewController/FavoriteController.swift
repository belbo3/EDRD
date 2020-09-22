//
//  FavoriteController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit
import PromiseKit

func initialFavoriteController(crudService: CRUDService<Favorite> = crudService()) -> UINavigationController {
  let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
  
  let favoriteController = storyboard.instantiateViewController(withIdentifier: "FavoriteController") as! FavoriteController
  favoriteController.crudService = crudService
  
  let favoriteControllerNavigation = UINavigationController(rootViewController: favoriteController)
  favoriteControllerNavigation.tabBarItem.title = "Favorites"
  favoriteControllerNavigation.tabBarItem.image = .icFavorite
  
  return favoriteControllerNavigation
}

final class FavoriteController: UIViewController {
  // MARK: - Properties
  
  private var mainView: FavoriteView {
    get { view as! FavoriteView }
  }
  
  private var models = [PersonModelSection]() {
    didSet {
      mainView.tableView.reloadData()
    }
  }
  
  var crudService: CRUDService<Favorite>!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Favorite"
    
    mainView.tableView.dataSource = self
    mainView.tableView.delegate = self
    
    mainView.tableView.register(PersonInfoCell.self)
    
    crudService.observer = { [unowned self] in
      switch $0 {
      case .obtained(let models):
        let items: [PersonModelItem] = models.compactMap { item in
          var bookAction: Action? = {[unowned self] in self.bookAction(link: item.linkPDF)}
          if item.linkPDF == nil {
            bookAction = nil
          }
          return .person(fullName: "\(item.lastName ?? "") \(item.firstName ?? "")",
            job: "\(item.placeOfWork ?? "")",
            position: "\(item.position ?? "")",
            comment: item.comment,
            id: item.id,
            bookAction: bookAction,
            markAction: {[unowned self] in self.markAction(person: item)})
        }
        self.models = [PersonModelSection(items: items)]
      case .deleted(_), .updated(_), .created(_):
        self.fetchFavorites()
      default:
        break
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchFavorites()
  }
  
  // MARK: - Private methods
  
  private func fetchFavorites() {
    crudService.readObserver(modelType: .favorite, sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)])
  }
  
  private func update(id: String, comment: String?) {
    let entity = crudService.read(modelType: .favorite, predicates: [NSPredicate(format: "id == %@", id)])
    let persons = entity.value
    _ = persons?.compactMap {
      $0.comment = comment
      crudService.updateObserver(model: $0)
    }
  }
  
  // MARK: - Actions
  
  private func bookAction(link: String?) {
    guard let link = link else { return }
    navigationController?.pushViewController(inititalPDFViewController(pdfLink: link), animated: true)
  }
  
  private func markAction(person: Favorite) {
    crudService.deleteObserver(model: person)
  }
}

// MARK: - UITableViewDataSource

extension FavoriteController: UITableViewDataSource {
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

// MARK: - UITableViewDelegate

extension FavoriteController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = models[indexPath.section].items[indexPath.row]
    switch model {
    case let .person(_, _, _, comment, id, _, _):
      present(initialCommentController(comment: comment, callBack: {[unowned self] comment in self.update(id: id, comment: comment) }), animated: true, completion: nil)
    }
  }
}
