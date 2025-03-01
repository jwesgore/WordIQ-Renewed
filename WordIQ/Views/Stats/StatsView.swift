import SwiftUI
import Charts

/// View container for Stats
struct StatsView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var databaseHelper: GameDatabaseHelper?
    
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text(SystemNames.GameStats.title)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Text("Done")
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                })
            }
            .padding(.bottom)
            
            if let databaseHelper = databaseHelper {
                ScrollView {
                    StatsGeneralView(databaseHelper: databaseHelper)
                    StatsDailyModeView(databaseHelper: databaseHelper)
                    StatsStandardModeView(databaseHelper: databaseHelper)
                    StatsRushModeView(databaseHelper: databaseHelper)
                    StatsFrenzyModeView(databaseHelper: databaseHelper)
                    StatsZenModeView(databaseHelper: databaseHelper)
                }
            } else {
                Text("Loading data...")
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    .onAppear {
                        self.databaseHelper = GameDatabaseHelper(context: viewContext)
                    }
            }
            
            Spacer()
            
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    StatsView(isPresented: .constant(true))
        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
}
