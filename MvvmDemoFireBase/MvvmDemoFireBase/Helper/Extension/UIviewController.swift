//
//  UIviewController.swift
//  MvvmDemoFireBase
//
//  Created by mac on 14/11/22.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    class func instantiate<T: UIViewController>(appStoryboard: String) -> T {
        let storyboard = UIStoryboard(name: appStoryboard, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func showHUD(progressLabel:String){
        DispatchQueue.main.async{
            let progressHUD = MBProgressHUD.showAdded(to: (Utils.shared.getSceneDelegate()?.window)!, animated: true)
            progressHUD.label.text = progressLabel
        }
    }

    func dismissHUD(isAnimated:Bool) {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: (Utils.shared.getSceneDelegate()?.window)!, animated: isAnimated)
        }
    }
    
    func showAlertWithOutTitle(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(msg: String, title: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)
    }
}

extension Convertable {
    func convertToDict() -> Dictionary<String, Any>? {
        var dict: Dictionary<String, Any>? = nil
        do {
            print("init student")
            let encoder = JSONEncoder()

            let data = try encoder.encode(self)
            print("struct convert to data")

            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>

        } catch {
            print(error)
        }
        return dict
    }
}
