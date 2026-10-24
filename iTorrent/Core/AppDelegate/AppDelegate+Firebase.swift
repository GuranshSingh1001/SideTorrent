//
//  AppDelegate+Firebase.swift
//  iTorrent
//
//  Created by Даниил Виноградов on 20.04.2024.
//

import Foundation
#if canImport(FirebaseCore)
import FirebaseCore
#endif

extension AppDelegate {
    func registerFirebase() {
#if canImport(FirebaseCore) && !UNSIGNED_IPA_BUILD
        FirebaseApp.configure()
#endif
    }
}
