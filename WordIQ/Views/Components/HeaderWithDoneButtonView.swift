import SwiftUI

struct HeaderWithDoneButtonView: View {
    
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .robotoSlabFont(.title1, .semiBold)
                .frame(maxWidth: .infinity, alignment: .leading)
          
            Button {
                isPresented.toggle()
            } label: {
                Text("Done")
                    .robotoSlabFont(.headline, .semiBold)
            }
        }
    }
}
