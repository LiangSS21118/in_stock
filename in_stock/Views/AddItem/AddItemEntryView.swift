import SwiftUI

struct AddItemEntryView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject var addItemViewModel: AddItemViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        self._addItemViewModel = StateObject(wrappedValue: AddItemViewModel(spaces: appViewModel.spaces))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Text("新增物品")
                    .font(AppTheme.titleFont)
                    .padding(.top, 40)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: NaturalLanguageInputView(viewModel: addItemViewModel, appViewModel: appViewModel)) {
                        HStack(spacing: 20) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("自然語言輸入")
                                    .font(AppTheme.headerFont)
                                    .foregroundColor(.black)
                                Text("輸入文字，AI 自動解析品項與日期")
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
                    }
                    
                    NavigationLink(destination: CameraRecognitionView(viewModel: addItemViewModel, appViewModel: appViewModel)) {
                        HStack(spacing: 20) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("相機自動辨識")
                                    .font(AppTheme.headerFont)
                                    .foregroundColor(.black)
                                Text("拍照辨識物品、數量與到期日")
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(AppTheme.backgroundColor)
        }
    }
}
