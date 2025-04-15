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
                    .robotoSlabFont(.title2, .semiBold)
                Image(systemName: isExpanded ? SFAssets.downArrow.rawValue : SFAssets.upArrow.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: RobotoSlabOptions.Size.title2.rawValue, maxHeight: RobotoSlabOptions.Size.title2.rawValue)
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
