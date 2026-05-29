import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("currentUserName") var currentUserName: String = ""
    @AppStorage("currentUserEmail") var currentUserEmail: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func login(email: String, password: String) {
        isLoading = true
        // Mock login delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            if !email.isEmpty && !password.isEmpty {
                self.isLoggedIn = true
                self.currentUserName = "UserName"
                self.currentUserEmail = email
            } else {
                self.errorMessage = "請輸入有效的信箱與密碼"
            }
        }
    }
    
    func register(name: String, email: String, password: String) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                self.isLoggedIn = true
                self.currentUserName = name
                self.currentUserEmail = email
            } else {
                self.errorMessage = "請填寫完整註冊資訊"
            }
        }
    }
    
    func logout() {
        isLoggedIn = false
        currentUserName = ""
        currentUserEmail = ""
    }
}
