//
//  Utils.swift
//  MvvmDemoFireBase
//
//  Created by mac on 03/11/22.
//

import UIKit

class Utils {
    static var shared = Utils()
    
    func getSceneDelegate() -> SceneDelegate? {
        guard let delegate = UIApplication.shared.connectedScenes.first else { return nil }
        return delegate.delegate as? SceneDelegate ?? nil
    }
}
