import Foundation
import SwiftUICore

final class UpdatingPriceViewModel {
    var color: Color = .clear
    
    func correctColor(newPrice: String, oldPrice: Double) -> Color {
        let newPrice = (newPrice as NSString).doubleValue
        return newPrice > oldPrice ? .green : .red
    }
}
