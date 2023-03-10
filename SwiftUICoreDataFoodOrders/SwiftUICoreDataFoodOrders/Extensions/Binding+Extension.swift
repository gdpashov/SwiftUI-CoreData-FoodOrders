//
//  Binding+Extension.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 22.02.23.
//

import SwiftUI

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        // Ensure a non-nil value in `source`.
        if source.wrappedValue == nil {
            source.wrappedValue = defaultValue
        }
        // Unsafe unwrap because *we* know it's non-nil now.
        self.init(source)!
    }
}
