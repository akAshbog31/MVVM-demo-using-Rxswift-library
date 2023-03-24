//
//  NewsCellViewModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 01/12/22.
//

import UIKit

class NewsCellViewModel {
    var title: String
    var description: String
    var imgUrl: URL?
    
    init(articles: ArticlesModel) {
        self.title = articles.title ?? ""
        self.description = articles.description ?? ""
        self.imgUrl = getImgUrl(imgString: articles.urlToImage ?? "")
    }
    
    func getImgUrl(imgString: String) -> URL? {
        return URL(string: imgString)
    }
}
