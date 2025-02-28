import SwiftUI

struct KeyboardFunctionView : View {
    
    @ObservedObject var functionVM : KeyboardFunctionViewModel
    
    init(_ functionVM: KeyboardFunctionViewModel) {
        self.functionVM = functionVM
    }
    
    var body: some View {
        Button(
            action: {
                Haptics.shared.impact(.light)
                functionVM.PerformAction()
            },
            label: {
                Image(systemName: functionVM.keyboardFunction.symbol)
                    .foregroundStyle(functionVM.fontColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        )
        .frame(width:functionVM.width, height: functionVM.height)
        .background(functionVM.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: functionVM.cornerRadius)
                .stroke(functionVM.borderColor, lineWidth: functionVM.borderThickness)
        )
        .clipShape(RoundedRectangle(cornerRadius: functionVM.cornerRadius))
    }
}
