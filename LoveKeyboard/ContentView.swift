import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                headerSection
                setupGuideSection
                Spacer()
            }
            .padding()
            .navigationTitle("LoveKeyboard")
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "keyboard")
                .font(.system(size: 60))
                .foregroundColor(.pink)
            Text("爱键盘")
                .font(.title)
                .fontWeight(.bold)
            Text("让聊天更有爱")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
    }

    private var setupGuideSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("设置指南")
                .font(.headline)

            SetupStepView(step: "1", title: "打开设置")
            SetupStepView(step: "2", title: "通用 > 键盘")
            SetupStepView(step: "3", title: "添加新键盘")
            SetupStepView(step: "4", title: "选择 LoveKeyboard")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SetupStepView: View {
    let step: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Text(step)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.pink)
                .clipShape(Circle())
            Text(title)
                .font(.subheadline)
        }
    }
}
