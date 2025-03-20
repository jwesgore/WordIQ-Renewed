import SwiftUI

struct AppHeaderView : View {
    
    @Binding var displayStats: Bool
    @Binding var displaySettings: Bool
    
    var body : some View {
        HStack {
            Text(SystemNames.Title.title)
                .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
            Spacer()
            Button {
                displayStats = true
            } label: {
                Image(systemName: SFAssets.stats)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2))
            }
            .padding(.horizontal, 5)
            
            Button {
                displaySettings = true
            } label: {
                Image(systemName: SFAssets.settings)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2))
            }
        }
    }
}
