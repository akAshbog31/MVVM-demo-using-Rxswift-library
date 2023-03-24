//
//  FireBaseManager.swift
//  MvvmDemoFireBase
//
//  Created by mac on 03/11/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import RxSwift

var userDefaultId = "userDefaultId"

class FirebaseManager {
    
    static var shared = FirebaseManager()
    var db = Firestore.firestore()
    
    func saveUserDefaultId(id: String) {
        UserDefaults.standard.set(id, forKey: userDefaultId)
    }
    
    func createUser(email: String, password: String) -> Observable<UserProfileModel> {
        return Observable<UserProfileModel>.create { [weak self] observer in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let uid = result?.user.uid {
                    self?.saveUserDefaultId(id: uid)
                }
                observer.onNext(UserProfileModel(name: result?.user.displayName, email: result?.user.email, id: result?.user.uid))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func addUser(model: UserProfileModel, userId: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            self?.db.collection("Users").document(userId).setData(model.convertToDict() ?? [:]) { error in
                if let err = error {
                    observer.onError(err)
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func signIn(email: String, password: String)  -> Observable<Void> {
        return Observable<Void>.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authresult, error in
                if let err = error {
                    observer.onError(err)
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

