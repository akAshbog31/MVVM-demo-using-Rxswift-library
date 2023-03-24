//
//  LogInViewController.swift
//  MvvmDemoFireBase
//
//  Created by mac on 03/11/22.
//

import UIKit
import RxSwift

class LogInViewController: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    //MARK: - Properties
    private var logInViewModel = LogInViewModel()
    private var bag = DisposeBag()
    private var input = PublishSubject<LogInViewModel.Input>()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        bindToViewModel()
    }
    
    //MARK: - @IBAction
    @IBAction func onTapBtnLogIn(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty else {
            showAlertWithOutTitle(msg: "Plese Enter Valid Email")
            return
        }
        
        guard let password = txtPassword.text, !password.isEmpty else {
            showAlertWithOutTitle(msg: "Plese Enter Valid password")
            return
        }
        
        input.onNext(.onTapBtnLogIn(email: email, password: password))
    }
    
    @IBAction func onTApDontHaveAnAccount(_ sender: UIButton) {
        let signUpVc: SignUpViewController = SignUpViewController.instantiate(appStoryboard: "Main")
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    @IBAction private func eyeButtonAction(_ sender: UIButton) {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
        sender.setImage(UIImage(systemName: self.txtPassword.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
    }
    //MARK: - Functions
    private func setUpUi() {
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        removeShadow(view: viewEmail)
        removeShadow(view: viewPassword)
    }
    
    func setTextFieldShadow(txtField: UITextField) {
        txtField == txtEmail ? viewEmail.setShadow(shadowColor: UIColor(hexaRGBA: "FF8989") ?? UIColor.lightGray) : removeShadow(view: viewEmail)
        
        txtField == txtPassword ? viewPassword.setShadow(shadowColor: UIColor(hexaRGBA: "FF8989") ?? UIColor.lightGray) : removeShadow(view: viewPassword)
    }
    
    func removeShadow(view: UIView) {
        view.setShadow(shadowColor:  UIColor.lightGray)
    }
    
}

//MARK: - BindData
extension LogInViewController {
    func bindToViewModel() {
        logInViewModel.transform(input: input.asObserver()).subscribe { [weak self] event in
            guard let event = event.element else { return }
            switch event {
            case .loadingState(let isLoading):
                isLoading ? self?.showHUD(progressLabel: "Loading...") : self?.dismissHUD(isAnimated: true)
            case .errorMsg(let errorMsg):
                self?.showAlertWithOutTitle(msg: errorMsg)
            case .loginSuccess:
                let homeVc: HomeVc = HomeVc.instantiate(appStoryboard: "Main")
                self?.navigationController?.pushViewController(homeVc, animated: true)
            }
        }.disposed(by: bag)
    }
}

//MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setTextFieldShadow(txtField: textField)
        return true
    }
}
