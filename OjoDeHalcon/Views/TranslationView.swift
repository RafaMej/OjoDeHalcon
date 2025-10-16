import SwiftUI

struct TranscriptionView: View {
    @StateObject private var manager = TranscriptionManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Live Transcription")
                .font(.title)

            ScrollView {
                Text(manager.transcribedText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .frame(height: 200)

            Button(action: {
                if manager.isTranscribing {
                    manager.stopTranscribing()
                } else {
                    manager.startTranscribing()
                }
            }) {
                Text(manager.isTranscribing ? "Stop" : "Start")
                    .font(.headline)
                    .padding()
                    .background(manager.isTranscribing ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    TranscriptionView()
}
