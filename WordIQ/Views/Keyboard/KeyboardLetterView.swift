import SwiftUI

struct KeyboardLetterView : View {
    
    @ObservedObject var letterVM : KeyboardLetterViewModel
    
    init(_ letterVM: KeyboardLetterViewModel) {
        self.letterVM = letterVM
    }
    
    var body: some View {
        Button {
            HapticsHelper.shared.impact(.medium)
            letterVM.PerformAction()
        } label: {
            Text(letterVM.letter.stringValue)
                .robotoSlabFont(.title2, .regular)
                .foregroundStyle(letterVM.fontColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width:letterVM.width, height: letterVM.height)
        .background(letterVM.backgroundColor.color)
        .overlay(
            RoundedRectangle(cornerRadius: letterVM.cornerRadius)
                .stroke(letterVM.borderColor, lineWidth: letterVM.borderThickness)
        )
        .clipShape(RoundedRectangle(cornerRadius: letterVM.cornerRadius))
        .sensoryFeedback(.impact(weight: .light), trigger: true)

    }
}

#Preview {
    VStack {
        HStack{
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
        }
        HStack{
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            
        }
        HStack{
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
        }
    }
}
