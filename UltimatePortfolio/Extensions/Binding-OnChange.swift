//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 10/4/22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> ()) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
