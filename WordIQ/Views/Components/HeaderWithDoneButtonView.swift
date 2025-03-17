import SwiftUI

struct HeaderWithDoneButtonView: View {
    
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom(RobotoSlabOptions.Weight.semiBold, fixedSize: CGFloat(RobotoSlabOptions.Size.title1)))
                .frame(maxWidth: .infinity, alignment: .leading)
          
            Button {
                isPresented.toggle()
            } label: {
                Text("Done")
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, fixedSize: CGFloat(RobotoSlabOptions.Size.headline)))
            }
        }
    }
}
