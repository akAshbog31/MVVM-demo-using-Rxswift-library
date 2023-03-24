//
//  NewsModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 01/12/22.
//

import Foundation

struct NewsModel: Convertable {
    var status: String?
    var totalResults: Int?
    var articles: [ArticlesModel]?
}

struct ArticlesModel: Convertable {
    var source: Source?
    var author, title, description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Convertable {
    var id: String?
    var name: String?
}
