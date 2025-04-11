import SwiftUI
import SwiftData
import Charts

/// View container for Stats
struct StatsView : View {
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var databaseHelper: GameDatabaseHelper?
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack (spacing: 0) {

            HeaderWithDoneButtonView(title: SystemNames.GameStats.title, isPresented: $isPresented)
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            if let databaseHelper = databaseHelper {
                ScrollView {
                    VStack {
                        StatsGeneralView(databaseHelper)
                        StatsDailyModeView(databaseHelper: databaseHelper)
                        StatsStandardModeView(databaseHelper: databaseHelper)
                        StatsRushModeView(databaseHelper: databaseHelper)
                        StatsFrenzyModeView(databaseHelper: databaseHelper)
                        StatsZenModeView(databaseHelper: databaseHelper)
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("Loading data...")
                    .robotoSlabFont(.title2, .semiBold)
                    .onAppear {
                        self.databaseHelper = GameDatabaseHelper(context: modelContext)
                    }
            }
        }
        .background(Color.appBackground)
        .padding(.bottom, 32)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct StatsViewHelper {
    static let baseHeaderPadding = 2.0
    static let additionalHeaderPadding = 8.0
    static let vStackSpacing = 0.0
}

//#Preview {
//    StatsView(isPresented: .constant(true))
//        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
//}
