//
//  HomeVc.swift
//  MvvmDemoFireBase
//
//  Created by mac on 04/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVc: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblNewsList: UITableView!
    
    //MARK: - Properties
    private var bag = DisposeBag()
    private var input = PublishSubject<HomeViewModel.Input>()
    private let homeViewModel: HomeViewModel = HomeViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        setUpTblView()
        bindings()
        input.onNext(.onTapBtnSearch(query: "India"))
    }
    
    //MARK: - @IBAction
    @IBAction func onTapSearchBtn(_ sender: UIButton) {
        guard let text = txtSearch.text, !text.isEmpty else {return}
        
        input.onNext(.onTapBtnSearch(query: text))
    }
    
    //MARK: - Functions
    private func setUpUi() {
        viewSearch.layer.cornerRadius = viewSearch.frame.height / 2
        viewSearch.layer.borderColor = UIColor(hexaRGBA: "FF8989")?.cgColor
        viewSearch.layer.borderWidth = 0.5
        
        btnSearch.layer.cornerRadius = btnSearch.frame.height / 2
        btnSearch.layer.borderWidth = 0.5
        btnSearch.layer.borderColor = UIColor(hexaRGBA: "FF8989")?.cgColor
    }
    
    func setUpTblView() {
        tblNewsList.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        
        homeViewModel.newsData.bind(to: tblNewsList.rx.items) { (tv, row, item) in
            guard let cell = tv.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell else { return .init() }
            cell.articles = item
            return cell
        }.disposed(by: bag)
        
        tblNewsList.rx.modelSelected(ArticlesModel.self).subscribe { [weak self] item in
            guard let self = self else { return }
            let newsDetailVc: NewsDetailVc = NewsDetailVc.instantiate(appStoryboard: "Main")
            newsDetailVc.articlesModel = item.element
            self.navigationController?.pushViewController(newsDetailVc, animated: true)
        }.disposed(by: bag)
    }
}

//MARK: - BindingViewModel
extension HomeVc {
    private func bindings() {
        homeViewModel.transform(input: input.asObservable()).subscribe { [weak self] event in
            guard let event = event.element else { return }
            switch event {
            case .loadingState(let isLoading):
                isLoading ? self?.showHUD(progressLabel: "Loading...") : self?.dismissHUD(isAnimated: true)
            case .errorMsg(let errorMsg):
                self?.showAlertWithOutTitle(msg: errorMsg)
            }
        }.disposed(by: bag)
    }
}
