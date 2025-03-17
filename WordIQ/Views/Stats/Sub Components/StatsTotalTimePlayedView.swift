import SwiftUI

struct StatsTotalTimePlayedView : View {
    var totalTimePlayed: Int
    var totalGamesPlayed: Int
    
    var body: some View {
        GroupBox {
            HStack {
                Text("You have spent a total of ") +
                Text(TimeUtility.formatTimeLong(totalTimePlayed))
                    .fontWeight(.semibold) +
                Text(" playing ") +
                Text(totalGamesPlayed.description)
                    .fontWeight(.semibold) +
                Text(" games.")
                    .fontWeight(.semibold)
                Spacer()
            }
            .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.subheading)))
        }
        .frame(maxWidth: .infinity)
        .backgroundStyle(Color.appGroupBox)
    }
}
