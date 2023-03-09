//
//  DiagonalStackView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 27.02.23.
//

import SwiftUI

struct DiagonalStackView<Content: View>: View {
    var maxItemsCount: Int = 3
    
    @ViewBuilder
    var viewBuilderForCell: () -> Content
    
    var body: some View {
        DiagonalStackLayout(maxItemsCount: maxItemsCount) {
            viewBuilderForCell()
        }
    }
}

// MARK: - DiagonalStackLayout

struct DiagonalStackLayout: Layout {
    var maxItemsCount: Int = 3
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let proposalSize = proposal.replacingUnspecifiedDimensions(by: CGSize(width: 60, height: 60))
        let minBound = min(proposalSize.width, proposalSize.height)
        return CGSize(width: minBound, height: minBound)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let proposalSize = proposal.replacingUnspecifiedDimensions(by: CGSize(width: 60, height: 60))
        let minBound = min(proposalSize.width, proposalSize.height)
        let size = CGSize(width: minBound, height: minBound)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let subviews = subviews.prefix(maxItemsCount)
        let subviewsCount = Double(subviews.count)
        let midIndex = (subviewsCount - 1) / 2
        let scale = 1 - log10(subviewsCount)
        let step: Double = subviewsCount > 1 ? minBound * (1 - scale) / (subviewsCount - 1) : 0
        
        for index in subviews.indices {
            let midIndexOffset = Double(index) - midIndex
            let stepOffset = step * midIndexOffset
            
            subviews[index].place(
                at: CGPoint(x: center.x + stepOffset, y: center.y + stepOffset),
                anchor: .center,
                proposal: ProposedViewSize(CGSize(width: size.width * scale, height: size.height * scale))
            )
        }
    }
}
