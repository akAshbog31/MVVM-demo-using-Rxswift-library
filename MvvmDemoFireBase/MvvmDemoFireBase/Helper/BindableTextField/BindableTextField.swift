//
//  BindableTextField.swift
//  MvvmDemoFireBase
//
//  Created by mac on 04/11/22.
//

import UIKit


class BindableTextField: UITextField {
    var textChanged: (String) -> () = { _ in}
    
    func bind(textChanged: @escaping ((String) -> ())) {
        self.textChanged = textChanged
        
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.textChanged(textField.text!)
    }
}
