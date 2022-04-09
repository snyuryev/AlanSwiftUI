//
//  AlanSwiftUIApp.swift
//  AlanSwiftUI
//
//  Created by Sergey Yuryev on 09.04.2022.
//

import SwiftUI

@main
struct AlanSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onLoad {
                UIApplication.shared.addAlan()
            }
        }
    }
}
