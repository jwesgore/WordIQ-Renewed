import SwiftUI
import Charts

/// View container for Stats
struct StatsView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var databaseHelper: GameDatabaseHelper?
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack (spacing: 0) {

            HeaderWithDoneButtonView(title: SystemNames.GameStats.title, isPresented: $isPresented)
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            if let databaseHelper = databaseHelper {
                ScrollView {
                    VStack (spacing: 10) {
                        StatsGeneralView(databaseHelper: databaseHelper)
                        StatsDailyModeView(databaseHelper: databaseHelper)
                        StatsStandardModeView(databaseHelper: databaseHelper)
                        StatsRushModeView(databaseHelper: databaseHelper)
                        StatsFrenzyModeView(databaseHelper: databaseHelper)
                        StatsZenModeView(databaseHelper: databaseHelper)
                    }
                    .padding([.horizontal, .bottom])
                }
            } else {
                Text("Loading data...")
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    .onAppear {
                        self.databaseHelper = GameDatabaseHelper(context: viewContext)
                    }
            }
        }
        .background(Color.appBackground)
        .padding(.bottom)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct StatsViewHelper {
    static let baseHeaderPadding = 2.0
    static let additionalHeaderPadding = 8.0
    static let vStackSpacing = 0.0
}

#Preview {
    StatsView(isPresented: .constant(true))
        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
}
