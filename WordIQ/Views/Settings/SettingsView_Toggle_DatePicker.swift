import SwiftUI

/// View of a game settings toggle with a date picker, used for setting the notification times
struct SettingsView_Toggle_DatePicker : View {
    var label: String
    @Binding var isActive: Bool
    @Binding var time: Date
    
    var body: some View {
        VStack (spacing: 8.0) {
            SettingsView_Toggle(label, labelSize: .headline, labelWeight: .regular, isActive: $isActive)
            
            if isActive {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 3)
                    .robotoSlabFont(.headline, .regular)
            }
        }
    }
}

extension SettingsView_Toggle_DatePicker {
    init(_ label: String, isActive: Binding<Bool>, time: Binding<Date>) {
        self.label = label
        self._isActive = isActive
        self._time = time
    }
}
