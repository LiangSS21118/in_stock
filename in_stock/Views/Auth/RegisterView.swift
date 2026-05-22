import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("建立帳號")
                    .font(AppTheme.titleFont)
                Text("開始有條理的生活")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                AuthTextField(placeholder: "姓名", text: $name)
                AuthTextField(placeholder: "電子信箱", text: $email)
                AuthTextField(placeholder: "密碼", text: $password, isSecure: true)
            }
            
            PrimaryButton(title: viewModel.isLoading ? "註冊中..." : "註冊", action: {
                viewModel.register(name: name, email: email, password: password)
            }, isDisabled: viewModel.isLoading)
            
            Spacer()
        }
        .padding(24)
        .background(AppTheme.backgroundColor)
        .navigationBarBackButtonHidden(false)
    }
}
