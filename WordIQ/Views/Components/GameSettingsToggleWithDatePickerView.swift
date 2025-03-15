import SwiftUI

struct GameSettingsToggleWithDatePickerView : View {
    var label: String
    @Binding var isActive: Bool
    @Binding var time: Date
    
    var body: some View {
        VStack {
            Toggle(label, isOn: $isActive)
                .tint(.gray)
            
            if isActive {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .padding(.top, 3)
            }
        }
        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
    }
}

extension GameSettingsToggleWithDatePickerView {
    init(_ label: String, isActive: Binding<Bool>, time: Binding<Date>) {
        self.label = label
        self._isActive = isActive
        self._time = time
    }
}
