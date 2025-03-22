import SwiftUI

struct AppHeaderView : View {
    
    @Binding var displayStats: Bool
    @Binding var displaySettings: Bool
    
    var body : some View {
        HStack {
            Text(SystemNames.Title.title)
                .robotoSlabFont(.title2, .bold)
            Spacer()
            Button {
                displayStats = true
            } label: {
                Image(systemName: SFAssets.stats)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: RobotoSlabOptions.Size.title2.rawValue)
            }
            .padding(.horizontal, 5)
            
            Button {
                displaySettings = true
            } label: {
                Image(systemName: SFAssets.settings)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: RobotoSlabOptions.Size.title2.rawValue)
            }
        }
    }
}
