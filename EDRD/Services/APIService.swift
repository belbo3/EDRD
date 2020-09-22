//
//  APIService.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import PromiseKit
import Alamofire

func apiService() -> APIService {
  return APIService()
}

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
    return self.sharedInstance.isReachable
  }
}

enum apiError: Error {
  case connectionError
  case dataError
  case parseError
}

extension apiError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .connectionError:
      return "No internet Connection"
    case .dataError:
      return "Data error"
    case .parseError:
      return "Parse error"
    }
  }
}

final class APIService {
  // MARK: - Methods
  
  func download(_ urlString: String) -> Promise<Data> {
    return Promise { seal in
      if Connectivity.isConnectedToInternet {
        AF.request(urlString) { urlRequest in
          urlRequest.timeoutInterval = 5
          urlRequest.allowsConstrainedNetworkAccess = false
        }
        .response { request in
          if let data = request.data {
            seal.fulfill(data)
          } else {
            seal.reject(apiError.dataError)
          }
        }
      } else {
        seal.reject(apiError.connectionError)
      }
    }
  }
  
  func decode(data: Data) -> Promise<[PersonModelDecodableItem]> {
    return Promise { seal in
      do {
        let personArray = try JSONDecoder().decode(PersonModelDecodable.self, from: data)
        seal.fulfill(personArray.items)
      } catch {
        seal.reject(apiError.parseError)
      }
    }
  }
}
