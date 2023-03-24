//
//  NetworkManager.swift
//  MvvmDemoFireBase
//
//  Created by mac on 19/11/22.
//

import Foundation
import Moya
import RxSwift

protocol Networkable {
    var provider: MoyaProvider<Demo> { get }
    
    func getData(q: String, from: String?, sortBy: String?, apiKey: String?) -> Observable<NewsModel>
}

class NetworkManager: Networkable {
    static let shared = NetworkManager()
    
    var provider = MoyaProvider<Demo>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { target, items in
        if let log = items.first {
            print(log)
        }
    }, logOptions: .formatRequestAscURL))])
    
    func getData(q: String, from: String?, sortBy: String?, apiKey: String?) -> Observable<NewsModel> {
        request(target: .Everything(q: q, from: from ?? "2023-03-23", sortBy: sortBy ?? "publishedAt", apiKey: apiKey ?? "adf1d5885c5b42cbae8f0a95f84b83a9"))
    }
}

extension NetworkManager {
    func request<T: Codable>(target: Demo) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            self?.provider.request(target, completion: { result in
                switch result {
                case .success(let json):
                    do {
                        let model = try JSONDecoder().decode(T.self, from: json.data)
                        observer.on(.next(model))
                    } catch let error {
                        observer.on(.error(error))
                    }
                case .failure(let error):
                    observer.on(.error(error))
                }
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
