//
//  SquareTilingView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 27.02.23.
//

import SwiftUI

struct SquareTilingView<Content: View>: View {
    var preferredSpacing: Double = 10
    
    @ViewBuilder
    var viewBuilderForCell: (Int) -> Content
    
    var body: some View {
        GeometryReader { geometryProxy in
            let size = geometryProxy.size
            let heroHeight = min(size.height, (size.width - preferredSpacing) / 2)
            let tileHeight = (heroHeight - preferredSpacing) / 2
            let tilesColumns = floor((size.width - heroHeight) / (tileHeight + preferredSpacing))
            let horizontalSpacing = (size.width - heroHeight) / tilesColumns - tileHeight
            let itemsCount = 2 * tilesColumns + 1
            
            let iconShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
            SquareTilingLayout(tilesColumns: tilesColumns, tileHeight: tileHeight, horizontalSpacing: horizontalSpacing, verticalSpacing: preferredSpacing) {
                viewBuilderForCell(Int(itemsCount))
                    #if canImport(UIKit)
                    .background(Color(uiColor: .tertiarySystemFill), in: iconShape)
                    #else
                    .background(.quaternary.opacity(0.5), in: iconShape)
                    #endif
                    .overlay {
                        iconShape.strokeBorder(.quaternary, lineWidth: 0.5)
                    }
            }
        }
    }
}

// MARK: - SquareTilingLayout

struct SquareTilingLayout: Layout {
    var tilesColumns: Double = 2
    var tileHeight: Double = 100
    var horizontalSpacing: Double = 10
    var verticalSpacing: Double = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = proposal.replacingUnspecifiedDimensions(by: CGSize(width: 100, height: 100))
        let heroHeight = min(size.height, (size.width - verticalSpacing) / 2)
        let boundsWidth = heroHeight + (tileHeight + horizontalSpacing) * tilesColumns
        
        return CGSize(width: boundsWidth, height: heroHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let heroHeight = min(bounds.height, (bounds.width - verticalSpacing) / 2)
        let boundsWidth = heroHeight + (tileHeight + horizontalSpacing) * tilesColumns
        let heroOrigin = CGPoint(
            x: bounds.origin.x + (bounds.width - boundsWidth) / 2,
            y: bounds.origin.y + (bounds.height - heroHeight) / 2)
        
        let tilesOrigin = CGPoint(x: heroOrigin.x + heroHeight + horizontalSpacing, y: heroOrigin.y)
        
        for index in subviews.indices {
            if index == 0 {
                // Hero cell
                subviews[index].place(
                    at: heroOrigin,
                    anchor: .topLeading,
                    proposal: ProposedViewSize(width: heroHeight, height: heroHeight))
                
            } else {
                // Smaller tile
                let tileIndex = Double(index - 1)
                let xOffset = tileIndex.truncatingRemainder(dividingBy: tilesColumns)
                let yOffset = floor(tileIndex / tilesColumns)
                let point = CGPoint(
                    x: tilesOrigin.x + xOffset * (tileHeight + horizontalSpacing),
                    y: tilesOrigin.y + yOffset * (tileHeight + verticalSpacing))
                
                subviews[index].place(
                    at: point,
                    anchor: .topLeading,
                    proposal: ProposedViewSize(width: tileHeight, height: tileHeight))
            }
        }
    }
}
