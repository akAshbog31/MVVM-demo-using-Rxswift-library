//
//  LogInViewModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 03/11/22.
//

import RxSwift

final class LogInViewModel {
    //MARK: - Properties
    private var bag = DisposeBag()
    private var output = PublishSubject<Output>()
    
    //MARK: - LifeCycle
    enum Input {
        case onTapBtnLogIn(email: String, password: String)
    }
    
    enum Output {
        case loadingState(isLoading: Bool)
        case errorMsg(errorMsg: String)
        case loginSuccess
    }
    
    //MARK: - Functions
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.subscribe { [weak self] event in
            guard let event = event.element else { return }
            switch event {
            case .onTapBtnLogIn(let email, let password):
                self?.login(email: email, password: password)
            }
        }.disposed(by: bag)
        return output.asObserver()
    }
    
    private func login(email: String, password: String) {
        output.onNext(.loadingState(isLoading: true))
        FirebaseManager.shared.signIn(email: email, password: password).subscribe { [weak self] _ in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.output.onNext(.loginSuccess)
        } onError: { [weak self] error in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.output.onNext(.errorMsg(errorMsg: error.localizedDescription))
        }.disposed(by: bag)
    }
}
