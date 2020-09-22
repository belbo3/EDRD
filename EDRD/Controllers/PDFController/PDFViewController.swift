//
//  PDFViewController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 22.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit
import PDFKit
import PromiseKit

func inititalPDFViewController(pdfLink: String,
                               apiService: APIService = apiService()) -> UIViewController {
  let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
  
  let pdfController = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
  pdfController.pdfLink = pdfLink
  pdfController.apiService = apiService
  pdfController.title = "PDF"
  
  return pdfController
}

final class PDFViewController: UIViewController, AlertController {
  // MARK: - Properties
  
  var pdfLink: String!
  
  var apiService: APIService!
  
  lazy private var pdfView: PDFView! = {
    let pdfView = PDFView()
    pdfView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pdfView)
    
    pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    pdfView.autoScales = true
    pdfView.displayDirection = .vertical
    
    return pdfView
  }()
  
  // MARK: - LIfecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    download()
  }
  
  // MARK: - Private method
  
  private func download() {
    firstly {
      apiService.download(pdfLink)
    }.done {
      self.pdfView.document = PDFDocument(data: $0)
    }.catch {
      self.present(self.showAlert(title: $0.localizedDescription, message: nil, actions: []), animated: true, completion: nil)
    }
  }
}
