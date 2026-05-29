import SwiftUI

struct CameraRecognitionView: View {
    @ObservedObject var viewModel: AddItemViewModel
    @ObservedObject var appViewModel: AppViewModel
    @State private var showResult = false
    
    var body: some View {
        VStack {
            // Mock Camera Viewfinder
            ZStack {
                Color.black
                    .overlay(
                        Text("🥛") // Placeholder for item image
                            .font(.system(size: 100))
                            .opacity(0.8)
                    )
                
                // Corners
                VStack {
                    HStack {
                        CornerShape().rotationEffect(.degrees(0))
                        Spacer()
                        CornerShape().rotationEffect(.degrees(90))
                    }
                    Spacer()
                    HStack {
                        CornerShape().rotationEffect(.degrees(-90))
                        Spacer()
                        CornerShape().rotationEffect(.degrees(180))
                    }
                }
                .padding(60)
                
                if viewModel.isRecognizing {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]), startPoint: .top, endPoint: .bottom))
                        .frame(height: 100)
                        .offset(y: -100)
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: true)
                }
            }
            .frame(height: 400)
            .cornerRadius(24)
            .padding()
            
            if !showResult {
                Button(action: {
                    viewModel.mockCameraRecognition {
                        showResult = true
                    }
                }) {
                    Circle()
                        .stroke(Color.black, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .overlay(Circle().fill(Color.black).padding(8))
                }
                .disabled(viewModel.isRecognizing)
                .padding(.bottom, 40)
            } else {
                VStack(spacing: 16) {
                    Text("辨識結果（AI 自動辨識）")
                        .font(AppTheme.headerFont)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ResultRow(label: "品項", value: viewModel.itemName)
                        ResultRow(label: "數量", value: "\(Int(viewModel.quantity)) \(viewModel.unit)")
                        ResultRow(label: "到期日", value: dateFormatter.string(from: viewModel.expiryDate))
                        ResultRow(label: "所在空間", value: "\(spaceName) / \(viewModel.locationText)")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                    
                    NavigationLink(destination: AddItemConfirmView(viewModel: viewModel, appViewModel: appViewModel)) {
                        Text("確認並調整資訊")
                            .font(AppTheme.bodyFont.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(AppTheme.cornerRadius)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Spacer()
        }
        .background(AppTheme.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var spaceName: String {
        appViewModel.spaces.first(where: { $0.id == viewModel.selectedSpaceId })?.name ?? "未分類"
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        return f
    }
}

struct CornerShape: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 30))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 30, y: 0))
        }
        .stroke(Color.white, lineWidth: 4)
        .frame(width: 30, height: 30)
    }
}
