//
//  NetworkManager.swift
//  CodableRealm
//
//  Created by Cedan Misquith on 21/10/21.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    let decoder = JSONDecoder()
    let headersWithoutAuth: HTTPHeaders = [
        "Content-type": "application/json"
    ]
    var headersWithAuth: HTTPHeaders = [
        "Content-type": "application/json",
        "Authorization": "Bearer " + "TOKEN_GOES_HERE"
    ]
    enum RequestType {
        case withoutAuth
        case withAuth
    }
    enum MethodType {
        case GET
        case POST
        case PATCH
    }
    func makeNetworkRequest(urlString: String,
                            prametres: Any,
                            type: RequestType,
                            method: MethodType,
                            completion: @escaping(Data) -> Void) {
        let internetIsReachable = NetworkReachabilityManager()?.isReachable ?? false
        if !internetIsReachable {
            print("Please check your internet connection & try again.")
        } else {
            let url = NSURL(string: urlString)
            var request = URLRequest(url: url! as URL)
            switch type {
            case .withoutAuth:
                request.headers = headersWithoutAuth
            case .withAuth:
                request.headers = headersWithAuth
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: prametres,
                                                      options: JSONSerialization.WritingOptions.prettyPrinted)
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                switch method {
                case .GET:
                    request.httpMethod = "GET"
                case .POST:
                    request.httpMethod = "POST"
                    request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
                case .PATCH:
                    request.httpMethod = "PATCH"
                    request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
                }
                let alamoRequest = AF.request(request as URLRequestConvertible)
                alamoRequest.validate(statusCode: 200..<500)
                alamoRequest.responseJSON { response in
                    guard let data = response.data else { return }
                    completion(data)
                }
            } catch {
                print("Error in network request")
            }
        }
    }
}
