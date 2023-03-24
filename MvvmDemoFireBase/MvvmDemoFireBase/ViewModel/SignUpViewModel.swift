//
//  SignUpViewModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 14/11/22.
//

import RxSwift

final class SignUpViewModel {
    //MARK: - Properties
    private var bag = DisposeBag()
    private var output = PublishSubject<Output>()
    
    //MARK: - LifeCycle
    enum Input {
        case onTapBtnSignIn(name: String, email: String, password: String)
    }
    
    enum Output {
        case loadingState(isLoading: Bool)
        case errorMsg(errorMsg: String)
        case signInSuccess
    }
    
    //MARK: - Functions
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.subscribe { [weak self] event in
            guard let event = event.element else { return }
            switch event {
            case .onTapBtnSignIn(let name, let email, let password):
                self?.createUser(name: name, email: email, password: password)
            }
        }.disposed(by: bag)
        return output.asObserver()
    }
    
    private func createUser(name: String, email: String, password: String) {
        output.onNext(.loadingState(isLoading: true))
        FirebaseManager.shared.createUser(email: email, password: password).subscribe { [weak self] userModel in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.addUser(model: UserProfileModel(name: name, email: userModel.email, id: userModel.id))
        } onError: { [weak self] error in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.output.onNext(.errorMsg(errorMsg: error.localizedDescription))
        }.disposed(by: bag)
    }
    
    private func addUser(model: UserProfileModel) {
        output.onNext(.loadingState(isLoading: true))
        FirebaseManager.shared.addUser(model: model, userId: model.id ?? "").subscribe { [weak self] _ in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.output.onNext(.signInSuccess)
        } onError: { [weak self] error in
            self?.output.onNext(.loadingState(isLoading: false))
            self?.output.onNext(.errorMsg(errorMsg: error.localizedDescription))
        }.disposed(by: bag)
    }
}
