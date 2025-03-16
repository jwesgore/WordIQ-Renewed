import SwiftUI

struct ExpandAndCollapseHeaderView: View {
    
    let title: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                Text(title)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                Image(systemName: isExpanded ? SFAssets.downArrow : SFAssets.upArrow)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(NoAnimation())
    }
}
