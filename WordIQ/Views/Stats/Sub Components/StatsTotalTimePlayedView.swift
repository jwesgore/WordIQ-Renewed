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
            .robotoSlabFont(.subheading, .regular)
        }
        .frame(maxWidth: .infinity)
        .backgroundStyle(Color.appGroupBox)
    }
}
