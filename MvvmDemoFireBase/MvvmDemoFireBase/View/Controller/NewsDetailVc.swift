//
//  NewsDetailVc.swift
//  MvvmDemoFireBase
//
//  Created by mac on 01/12/22.
//

import UIKit

class NewsDetailVc: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblPublishAt: UILabel!
    @IBOutlet weak var lblGetFullDetail: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblContent: UILabel!
    
    //MARK: - Properties
    var articlesModel: ArticlesModel? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.loadData()
            }
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - @IBAction
    
    //MARK: - Fun
    private func loadData() {
        guard let articlesModel = articlesModel else { return }
        
        self.lblTitle.text = articlesModel.title
        self.lblContent.text = articlesModel.content
        self.lblCreatedBy.text = "Author: \(articlesModel.author ?? "")"
        self.lblPublishAt.text = "Publish At: \(articlesModel.publishedAt ?? "")"
        self.lblGetFullDetail.text = "Get full detail: \(articlesModel.url ?? "")"
        self.imgNews.sd_setImage(with: URL(string: articlesModel.urlToImage ?? ""), completed: nil)
    }
}
