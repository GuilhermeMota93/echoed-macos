import SwiftUI

struct FloatingNoteView: View {
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var currentDateText: String = ""
    
    var body: some View {
        VStack {
            // Display the current date in written format
            Text(currentDateText)
                .font(.headline)
            
            TextEditor(text: $transcribedText)
                .frame(minHeight: 100)
                .border(Color.gray, width: 1)
            
            HStack {
                Button(action: toggleRecording) {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                Button("Save") {
                    // TODO: Implement save functionality
                }
            }
        }
        .padding()
        .frame(width: 400, height: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        // When the view appears, set the current date in written format
        .onAppear {
            currentDateText = formattedDate()
        }
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        // TODO: Implement actual recording logic
    }
    
    // Function to get the current date in a human-readable format
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full // Displays full day and date
        formatter.timeStyle = .short // Displays time (7:15 PM)
        return formatter.string(from: Date()) // Current date and time
    }
}

#Preview {
    FloatingNoteView()
}
