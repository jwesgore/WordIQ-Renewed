import SwiftUI
import SwiftData
import Charts

/// View container for Stats
struct StatsView : View {
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var databaseHelper: GameDatabaseClient?
    @StateObject private var viewModel: StatsViewModel = StatsViewModel()
    
    var body: some View {
        VStack (spacing: 0) {
            
            StatsView_Component_Filter(viewModel: viewModel)

            ScrollView (showsIndicators: false) {
                if let databaseHelper = databaseHelper {
                    StatsView_FilteredView(databaseHelper, filter: $viewModel.activeFilter)
                } else {
                    Text("Loading data...")
                        .robotoSlabFont(.title2, .semiBold)
                        .onAppear {
                            self.databaseHelper = GameDatabaseClient(context: modelContext)
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
