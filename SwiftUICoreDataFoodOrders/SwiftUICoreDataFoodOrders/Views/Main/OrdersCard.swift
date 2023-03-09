//
//  OrdersCard.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 28.02.23.
//

import SwiftUI

struct OrdersCard: View {
    @Binding var selection: SidebarSelection?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.statusDate, ascending: true)],
        predicate: NSPredicate(format: "isFinal == true AND statusCode != %@", Order.Status.completed.rawValue),
        animation: .default)
    var fetchedOrders: FetchedResults<Order>
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SidebarSelection.orders) {
                Label("Orders", systemImage: "cart")
                
                Spacer()
            }
            .onTapGesture {
                selection = .orders
            }
            .buttonStyle(.borderless)
            .labelStyle(CardNavigationHeaderLabelStyle())
            
            SquareTilingView { itemsCount in
                ForEach(getOrderProperties(fetchedOrders, maxOrdersCount: itemsCount - 1), id: \.id) { order in
                    NavigationLink(value: SidebarSelection.order(order)) {
                        VStack(spacing: 0) {
                            let orderFoods = (order.orderFoods?.allObjects ?? []) as! [OrderFood]
                            OrderImageView(orderFoods: orderFoods)
                            
                            VStack(spacing: 0) {
                                Text(order.name)
                                    .font(.footnote)
                                
                                HStack(spacing: 4) {
                                    order.status?.image
                                    Text(order.status?.title ?? "")
                                }
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .buttonStyle(.plain)
                    .padding(5)
                    // Patch to hide disclosure indicator
                    .padding(.trailing, -16)
                    .clipped()
                    .onTapGesture {
                        selection = .order(order)
                    }
                }
                
                // Add order
                NavigationLink(value: SidebarSelection.addFood) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .padding(10)
                        
                        Text("Add")
                            .font(.footnote)
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
                .padding(5)
                // Patch to hide disclosure indicator
                .padding(.trailing, -16)
                .clipped()
                .onTapGesture {
                    selection = .addOrder
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            
            Spacer()
        }
        .padding(5)
        .clipShape(ContainerRelativeShape())
        .background()
    }
    
    // MARK: - Functions
    
    private func getOrderProperties(_ fetchedOrders: FetchedResults<Order>, maxOrdersCount: Int) -> [Order] {
        return Array(fetchedOrders.prefix(maxOrdersCount))
    }
}
