import SwiftUI

/// Basic model for storing stats items
class InfoItemModel : ObservableObject {
    @Published var icon: String
    @Published var label: String
    @Published var value: String
    
    init(icon: String, label: String, value: String) {
        self.icon = icon
        self.label = label
        self.value = value
    }
}

/// Extension to allow for basic initialization
extension InfoItemModel {
    convenience init() {
        self.init(icon: "", label: "", value: "")
    }
}
