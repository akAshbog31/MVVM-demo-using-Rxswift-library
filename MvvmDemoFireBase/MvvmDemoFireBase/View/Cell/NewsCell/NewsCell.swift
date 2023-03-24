//
//  NewsCell.swift
//  MvvmDemoFireBase
//
//  Created by mac on 01/12/22.
//

import UIKit
import SDWebImage

class NewsCell: UITableViewCell {
    //MARK: - @IBOutlet
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblTitleNews: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    //MARK: - Properties
    var articles: ArticlesModel? {
        didSet {
            loadData()
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    //MARK: - @IBAction
    
    //MARK: - Functions
    private func loadData() {
        guard let articles = articles else { return }
        
        self.lblDescription.text = articles.description
        self.lblTitleNews.text = articles.title
        self.imgNews.sd_setImage(with: URL(string: articles.urlToImage ?? ""), completed: nil)
    }
    
}
