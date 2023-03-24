//
//  ViewController.swift
//  MvvmDemoFireBase
//
//  Created by mac on 03/11/22.
//

import UIKit
import RxSwift

class SignUpViewController: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var txtConformPassword: UITextField!
    @IBOutlet weak var btnEyePassWord: UIButton!
    @IBOutlet weak var btnEyeConformPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConformPassword: UIView!
    
    //MARK: - Properties
    private let signUpViewModel = SignUpViewModel()
    private var bag = DisposeBag()
    private var input = PublishSubject<SignUpViewModel.Input>()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        bindToViewModel()
    }
    
    //MARK: - @IBAction
    @IBAction func onTapSignUpBtn(_ sender: Any) {
        guard let name = txtUserName.text, !name.isEmpty else {
            showAlertWithOutTitle(msg: "Plese Enter Valid Name")
            return
        }
        
        guard let email = txtEmail.text, !email.isEmpty else {
            showAlertWithOutTitle(msg: "Plese Enter Valid Email")
            return
        }
        
        guard let password = txtPassWord.text, !password.isEmpty else {
            showAlertWithOutTitle(msg: "Plese Enter Valid password")
            return
        }
        
        guard let conformPassword = txtConformPassword.text, !conformPassword.isEmpty, conformPassword == password else {
            showAlertWithOutTitle(msg: "Plese Enter Valid conformPassword")
            return
        }
        
        input.onNext(.onTapBtnSignIn(name: name, email: email, password: password))
    }
    
    @IBAction func onTapAlreadyHaveAnAccount(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func eyeButtonAction(_ sender: UIButton) {
        if sender.tag == 10 {
            self.txtPassWord.isSecureTextEntry = !self.txtPassWord.isSecureTextEntry
            sender.setImage(UIImage(systemName: self.txtPassWord.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
        } else if sender.tag == 11 {
            self.txtConformPassword.isSecureTextEntry = !self.txtConformPassword.isSecureTextEntry
            sender.setImage(UIImage(systemName: self.txtConformPassword.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
        }
    }
    //MARK: - Functions
    private func setUpUi() {
        txtUserName.delegate = self
        txtEmail.delegate = self
        txtPassWord.delegate = self
        txtConformPassword.delegate = self
        
        removeShadow(view: viewName)
        removeShadow(view: viewEmail)
        removeShadow(view: viewPassword)
        removeShadow(view: viewConformPassword)
    }
    
    func setTextFieldShadow(txtField: UITextField) {
        txtField == txtUserName ? viewName.setShadow(shadowColor: UIColor(hexaRGBA: "FF8989") ?? UIColor.lightGray) : removeShadow(view: viewName)
        
        txtField == txtEmail ? viewEmail.setShadow(shadowColor: UIColor(hexaRGBA: "FF8989") ?? UIColor.lightGray) : removeShadow(view: viewEmail)
        
        txtField == txtPassWord ? viewPassword.setShadow(shadowColor: UIColor(hexaRGBA: "FF8989") ?? UIColor.lightGray) : removeShadow(view: viewPassword)
        
        txtField == txtConformPassword ? viewConformPassword.setShadow(shadowColor: UIColor(hexaRGBA: "FF8989") ?? UIColor.lightGray) : removeShadow(view: viewConformPassword)
    }
    
    func removeShadow(view: UIView) {
        view.setShadow(shadowColor:  UIColor.lightGray)
    }
}

//MARK: - bindToViewModel
extension SignUpViewController {
    func bindToViewModel() {
        signUpViewModel.transform(input: input.asObserver()).subscribe { [weak self] event in
            guard let event = event.element else { return }
            switch event {
            case .loadingState(let isLoading):
                isLoading ? self?.showHUD(progressLabel: "Loading...") : self?.dismissHUD(isAnimated: true)
            case .errorMsg(let errorMsg):
                self?.showAlertWithOutTitle(msg: errorMsg)
            case .signInSuccess:
                let logInVc: LogInViewController = LogInViewController.instantiate(appStoryboard: "Main")
                self?.navigationController?.pushViewController(logInVc, animated: true)
            }
        }.disposed(by: bag)
    }
}

//MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setTextFieldShadow(txtField: textField)
        return true
    }
}

