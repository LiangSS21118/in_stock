import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("In Stock")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                    Text("掌握家中物品的每一刻")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondaryText)
                }
                .padding(.bottom, 40)
                
                VStack(spacing: 16) {
                    AuthTextField(placeholder: "帳號名稱", text: $name)
                    AuthTextField(placeholder: "電子信箱", text: $email)
                    AuthTextField(placeholder: "密碼", text: $password, isSecure: true)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(AppTheme.captionFont)
                        .foregroundColor(.red)
                }
                
                PrimaryButton(title: viewModel.isLoading ? "登入中..." : "登入", action: {
                    viewModel.login(name: name, email: email, password: password)
                }, isDisabled: viewModel.isLoading)
                
                NavigationLink {
                    RegisterView(viewModel: viewModel)
                } label: {
                    Text("還沒有帳號？立即註冊")
                        .font(AppTheme.captionFont.bold())
                        .foregroundColor(AppTheme.primaryText)
                }
                
                Spacer()
            }
            .padding(24)
            .background(AppTheme.backgroundColor)
        }
    }
}
