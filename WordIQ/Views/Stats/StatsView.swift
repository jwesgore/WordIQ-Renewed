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
            
            StatsView_Component_Filter(viewModel: viewModel)

            ScrollView (showsIndicators: false) {
                if let databaseHelper = databaseHelper {
                    switch viewModel.activeFilter {
                    case .all:
                        StatsView_FilteredView_General(databaseHelper)
                    case .daily:
                        StatsView_FilteredView_Daily(databaseHelper: databaseHelper)
                    case .standard:
                        StatsView_FilteredView_Standard(databaseHelper: databaseHelper)
                    case .rush:
                        StatsView_FilteredView_Rush(databaseHelper: databaseHelper)
                    case .frenzy:
                        StatsView_FilteredView_Frenzy(databaseHelper: databaseHelper)
                    case .zen:
                        StatsView_FilteredView_Zen(databaseHelper: databaseHelper)
                    case .quadStandard:
                        StatsView_FilteredView_Quad(databaseHelper: databaseHelper)
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
