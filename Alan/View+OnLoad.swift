//
//  View+OnLoad.swift
//  AlanSwiftUI
//
//  Created by Sergey Yuryev on 09.04.2022.
//

import SwiftUI

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
