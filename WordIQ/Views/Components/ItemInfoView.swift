import SwiftUI

struct InfoItemView : View {
    
    var image: String
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .fontWeight(.semibold)
                .frame(width: 25)
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
    }
}
