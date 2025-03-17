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
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                Image(systemName: isExpanded ? SFAssets.downArrow : SFAssets.upArrow)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2), maxHeight: CGFloat(RobotoSlabOptions.Size.title2))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(NoAnimation())
    }
}

extension ExpandAndCollapseHeaderView {
    init (_ title: String, isExpanded: Binding<Bool>) {
        self.title = title
        self._isExpanded = isExpanded
    }
}
