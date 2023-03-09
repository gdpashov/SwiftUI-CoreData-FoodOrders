//
//  SwiftUICoreDataFoodOrdersApp.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

@main
struct SwiftUICoreDataFoodOrdersApp: App {
    @AppStorage("AppInitialized", store: .standard) var appInitialized = false
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    if !appInitialized {
                        // Load sample data on initialization
                        loadSampleData()
                        appInitialized.toggle()
                    }
                }
        }
    }
    
    // MARK: - Functions
    
    private func loadSampleData() {
        let viewContext = persistenceController.container.viewContext
        Food.loadSampleFoods(viewContext: viewContext)
        Order.loadSampleOrders(viewContext: viewContext)
        try! viewContext.save()
    }
}
