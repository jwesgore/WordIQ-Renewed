import SwiftUI

/// Info Item View
struct InfoItemView : View {
    
    @ObservedObject var infoItemModel : InfoItemModel
    
    init(_ infoItemModel: InfoItemModel) {
        self.infoItemModel = infoItemModel
    }
    
    var body: some View {
        HStack {
            Image(systemName: infoItemModel.icon)
                .fontWeight(.semibold)
                .frame(width: 25)
            Text(infoItemModel.label)
                .fontWeight(.semibold)
            Spacer()
            Text(infoItemModel.value)
        }
        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
    }
}

extension InfoItemView {
    init (icon: String, label: String, value: String) {
        self.init(InfoItemModel(icon: icon, label: label, value: value))
    }
}
