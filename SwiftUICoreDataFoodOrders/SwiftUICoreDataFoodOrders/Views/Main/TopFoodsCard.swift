//
//  TopFoodsCard.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 8.03.23.
//

import SwiftUI
import CoreData
import Charts
import Combine

struct TopFoodsCard: View {
    class FoodTotalCount /*: ObservableObject*/ {
        var food: Food
        var totalCount: Int
        
        init(food: Food, totalCount: Int) {
            self.food = food
            self.totalCount = totalCount
        }
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var fetchOrderFoodsRequest: NSFetchRequest<NSFetchRequestResult>
    
    @State
    private var foodTotalCounts: [FoodTotalCount] = []
    
    var maxFoodsCount = 5
    
    init(maxFoodsCount: Int = 5) {
        self.maxFoodsCount = maxFoodsCount
        
        fetchOrderFoodsRequest = TopFoodsCard.getFetchOrderFoodsRequest()
        fetchOrderFoodsRequest.fetchLimit = maxFoodsCount
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("Top Cakes", systemImage: "arrow.up")
                
                Spacer()
            }
            .buttonStyle(.borderless)
            .labelStyle(CardNavigationHeaderLabelStyle())
            
            chart
                .frame(height: 200)
            
            Spacer()
        }
        .padding(5)
        .clipShape(ContainerRelativeShape())
        .background()
        .onAppear {
            loadFoodTotalCount()
        }
    }
    
    var chart: some View {
        Chart {
            ForEach(foodTotalCounts, id: \.food) { foodTotalCount in
                BarMark(
                    x: .value("Cakes", foodTotalCount.food.id ?? ""),
                    y: .value("Pieces", foodTotalCount.totalCount)
                )
                .cornerRadius(6, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [Color("BarBottomColor"), .accentColor], startPoint: .bottom, endPoint: .top))
                .annotation(position: .top, alignment: .top) {
                    Text(foodTotalCount.totalCount.formatted())
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.quaternary.opacity(0.5), in: Capsule())
                        .background(in: Capsule())
                        .font(.caption)
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: IntegerFormatStyle<Int>())
            }
        }
        .chartXAxis {
            AxisMarks { value in
                let food = foodFromAxisValue(for: value)
                AxisValueLabel {
                    VStack {
                        CakeImageView(ingredients: food?.ingredients ?? [])
                            .frame(height: 35)
                            
                        Text(food?.name ?? "")
                            .lineLimit(2, reservesSpace: true)
                            .multilineTextAlignment(.center)
                    }
                    .frame(idealWidth: 80)
                    .padding(.horizontal, 4)
                }
            }
        }
        .padding(.top, 20)
    }
    
    func foodFromAxisValue(for value: AxisValue) -> Food? {
        guard let id = value.as(String.self) else {
            fatalError("Could not convert axis value to expected String type")
        }
        let result = foodTotalCounts.first(where: { $0.food.id == id })
        return result?.food
    }
    
    // MARK: - Functions
    
    private func loadFoodTotalCount() {
        if let result = try! viewContext.fetch(fetchOrderFoodsRequest) as? [[String: Any]] {
            foodTotalCounts = result.compactMap({
                if let foodObjectId = $0["food"] as? NSManagedObjectID, let food = viewContext.object(with: foodObjectId) as? Food, let totalCount = $0["totalCount"] as? Int {
                    return FoodTotalCount(food: food, totalCount: totalCount)
                } else {
                    return nil
                }
            })
        } else {
            foodTotalCounts = []
        }
    }
    
    private static func getFetchOrderFoodsRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let sumDesc = NSExpressionDescription()
        sumDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "count")])
        sumDesc.name = "totalCount"
        sumDesc.expressionResultType = .integer64AttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderFood")
        fetchRequest.predicate = NSPredicate(format: "food != nil")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToGroupBy = ["food"]
        fetchRequest.propertiesToFetch = ["food", sumDesc]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "totalCount", ascending: false)]
        fetchRequest.resultType = .dictionaryResultType
        
        return fetchRequest
    }
}
