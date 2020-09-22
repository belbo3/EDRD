//
//  PersonModelDecodable.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

struct PersonModelDecodable: Decodable {
  let items: [PersonModelDecodableItem]
}

struct PersonModelDecodableItem: Decodable {
  let firstname: String?
  let lastname: String?
  let placeOfWork: String?
  let position: String?
  let linkPDF: String?
  let id: String
}
