import SwiftUI
import SwiftData
import Charts

/// View container for Stats
struct StatsView : View {
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var databaseHelper: GameDatabaseHelper?
    @StateObject private var viewModel: StatsViewModel = StatsViewModel()
    
    var body: some View {
        VStack (spacing: 0) {
            
            StatsView_Filter(viewModel: viewModel)

            
            ScrollView {
                if let databaseHelper = databaseHelper {
                    switch viewModel.activeFilter {
                    case .all:
                        StatsGeneralView(databaseHelper)
                    case .daily:
                        StatsDailyModeView(databaseHelper: databaseHelper)
                    case .standard:
                        StatsStandardModeView(databaseHelper: databaseHelper)
                    case .rush:
                        StatsRushModeView(databaseHelper: databaseHelper)
                    case .frenzy:
                        StatsFrenzyModeView(databaseHelper: databaseHelper)
                    case .zen:
                        StatsZenModeView(databaseHelper: databaseHelper)
                    case .quadStandard:
                        Text("Temp")
                    case .twentyQuestions:
                        Text("Temp")
                    }
                } else {
                    Text("Loading data...")
                        .robotoSlabFont(.title2, .semiBold)
                        .onAppear {
                            self.databaseHelper = GameDatabaseHelper(context: modelContext)
                        }
                }
            }
            .padding()
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
