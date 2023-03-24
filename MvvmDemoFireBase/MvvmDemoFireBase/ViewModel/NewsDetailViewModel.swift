//
//  NewsDetailViewModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 01/12/22.
//

import UIKit

class NewsDetailViewModel {
    var title: String
    var auther: String
    var publishAt: String
    var fullDetailLink: String
    var imgNewsUrl: URL?
    var content: String
    
    init(articles: ArticlesModel) {
        self.title = articles.title ?? ""
        self.auther = articles.author ?? ""
        self.publishAt = articles.publishedAt ?? ""
        self.fullDetailLink = articles.url ?? ""
        self.content = articles.content ?? ""
        self.imgNewsUrl = getUrl(str: articles.urlToImage ?? "")
    }
    
    func getUrl(str: String) -> URL? {
        return URL(string: str)
    }
}
