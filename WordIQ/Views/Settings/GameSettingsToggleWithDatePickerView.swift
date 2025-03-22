import SwiftUI

/// View of a game settings toggle with a date picker, used for setting the notification times
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 3)
            }
        }
        .robotoSlabFont(.title3, .regular)
    }
}

extension GameSettingsToggleWithDatePickerView {
    init(_ label: String, isActive: Binding<Bool>, time: Binding<Date>) {
        self.label = label
        self._isActive = isActive
        self._time = time
    }
}
