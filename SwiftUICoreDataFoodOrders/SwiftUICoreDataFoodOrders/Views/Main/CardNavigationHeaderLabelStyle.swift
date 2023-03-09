//
//  CardNavigationHeaderLabelStyle.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 28.02.23.
//

import SwiftUI

struct CardNavigationHeaderLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            configuration.icon
                .foregroundColor(.secondary)
            
            configuration.title
        }
        .font(.headline)
        .imageScale(.large)
        .foregroundColor(.accentColor)
    }
}
