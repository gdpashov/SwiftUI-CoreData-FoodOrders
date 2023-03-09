//
//  MainView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

struct MainView: View {
    @State private var selection: SidebarSelection? = .orders
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            NavigationStack(path: $path) {
                DetailView(selection: $selection)
            }
        }
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
        #elseif os(iOS)
        #endif
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
