# SwiftUI-CoreData-FoodOrders

## About

This is an iOS mobile app and macOS app for ordering cakes. The main goal is to demonstrate the usage of SwiftUI and Core Data iOS SDK frameworks. Supports both iOS and macOS with dynamic view.

## Overview

The main views are:
- Sidebar: Contains portlets with the most important information at a glance as randomly chosen cakes, latest cake orders, and top popular cakes.

  <img src="/Assets/Images/01_SidebarScreenShot.jpg" width="200"/>
  
  > The most important things at a glance.

- Order: Allows ordering cakes and processing orders.

  <img src="/Assets/Images/02_OrderScreenShot.jpg" width="200"/>
  
  > Order the delicious cakes.

- Cakes: Contains a list of available cakes.

  <img src="/Assets/Images/03_CakesScreenShot.jpg" width="200"/>
  
  > Choose the right cake.

- Cake Lab: Make a cake to your taste.

  <img src="/Assets/Images/04_CakeScreenShot.jpg" width="200"/>
  
  > Make a cake to your taste.

## App Structure

### `Models`/`SwiftUICoreDataFoodOrders`

> Uses Core Data framework.

Core Data model:

- `Food` entity stores cake name and ingredients.

- `Order` keeps ordered cakes and the state of the order. Each order contains one or more lines for each included cake.

- `OrderFood` represents a separate line for each included cake and the number of pieces.

### `Views`/`Common`/`SquareTilingView`

> Uses SwiftUI framework.

A custom layout that places a leading square view followed by more views in two rows. The number of these additional views is calculated dynamically to fit the remaining place.

### `Views`/`Common`/`DiagonalStackView`

> Uses SwiftUI framework.

A custom layout that places up to a specified number of views (3 by default) diagonally inside a square aspect ratio.

### `Views`/`Main`/`MainView`

> Uses SwiftUI framework.

A split view with sidebar and detail view for the selected option.

### `Views`/`Main`/`FoodsCard` and `OrdersCard`

> Uses SwiftUI and Core Data frameworks.

Fetches the cakes and orders, and displays them.

### `Views`/`Main`/`TopFoodsCard`

> Uses SwiftUI and Core Data frameworks.

Calculates the total number of pieces grouped by cake and display the most popular ones.

```Swift
struct TopFoodsCard: View {
    ...
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
    
```

### `Views`/`Cake`/`CakesView`

> Uses SwiftUI and Core Data frameworks.

Displays the available cakes. Supports list and grid layouts. Allows filtering by name and sorting by name or flavor.

### `Views`/`Cake`/`CakeEditView`

> Uses SwiftUI and Core Data frameworks.

Makes a new cake or changes existing one. You can choose cake base, glaze, cream and topping by yourself.

### `Views`/`Order`/`OrdersView`

> Uses SwiftUI and Core Data frameworks.

Displays the orders. Supports list and grid layouts. Allows filtering by name and status (only uncompleted or all).

### `Views`/`Order`/`OrderEditView`

> Uses SwiftUI and Core Data frameworks.

Orders cakes and processes the order. You can choose one or multiple cakes and order one or more pieces from them.
