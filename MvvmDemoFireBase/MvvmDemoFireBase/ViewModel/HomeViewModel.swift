//
//  HomeViewModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 01/12/22.
//

import RxSwift

final class HomeViewModel {
    //MARK: - Properties
    private var disposeBag = DisposeBag()
    private var output = PublishSubject<Output>()
    private var networkable: Networkable
    var newsData = PublishSubject<[ArticlesModel]>()
    
    init(networkable: Networkable = NetworkManager()) {
        self.networkable = networkable
    }
    
    //MARK: - LifeCycle
    enum Input {
        case onTapBtnSearch(query: String)
    }
    
    enum Output {
        case loadingState(isLoading: Bool)
        case errorMsg(errorMsg: String)
    }
    
    //MARK: - Functions
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.subscribe { [weak self] event in
            guard let event = event.element else { return }
            switch event {
            case .onTapBtnSearch(let query):
                self?.getNewsData(query: query)
            }
        }.disposed(by: disposeBag)
        return output.asObservable()
    }
    
    private func getNewsData(query: String) {
        output.onNext(.loadingState(isLoading: true))
        networkable.getData(q: query, from: nil, sortBy: nil, apiKey: nil).subscribe { [weak self] model in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.newsData.onNext(model.articles ?? [])
        } onError: { [weak self] error in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.output.onNext(.errorMsg(errorMsg: error.localizedDescription))
        }.disposed(by: disposeBag)
    }
}
