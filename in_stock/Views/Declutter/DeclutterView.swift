import SwiftUI

struct DeclutterView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isShowingNewItem = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("斷捨離清單")
                        .font(AppTheme.titleFont)
                    Text("整理不需要的物品，讓空間與心更輕盈。")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondaryText)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                VStack(spacing: 16) {
                    ForEach(viewModel.declutterItems) { item in
                        NavigationLink(destination: DeclutterDetailView(viewModel: viewModel, item: item)) {
                            DeclutterRow(item: item)
                        }
                    }
                }
                .padding(.horizontal)

                PrimaryButton(title: "＋ 新增斷捨離項目", action: {
                    isShowingNewItem = true
                })
                    .padding(.horizontal)
                    .padding(.top, 20)

                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.backgroundColor)
        .sheet(isPresented: $isShowingNewItem) {
            NewDeclutterItemSheet(viewModel: viewModel, isPresented: $isShowingNewItem)
                .presentationDetents([.height(420)])
        }
    }
}

struct DeclutterRow: View {
    let item: DeclutterItem
    
    var body: some View {
        HStack(spacing: 16) {
            Text(item.imageName)
                .font(.system(size: 32))
                .frame(width: 60, height: 60)
                .background(Color(white: 0.95))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    Text(item.locationText)
                    Text("•")
                    Text(AppDateFormatter.fullDateString(from: item.createdAt))
                }
                .font(.system(size: 10))
                .foregroundColor(.gray)
                
                StatusBadge(
                    text: item.action.rawValue,
                    backgroundColor: badgeColor(item.action).opacity(0.1),
                    textColor: badgeColor(item.action)
                )
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(AppTheme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
    }

    private func badgeColor(_ action: DeclutterAction) -> Color {
        switch action {
        case .donate: return .green
        case .sellSecondHand: return .orange
        case .discard: return .red
        }
    }
}

private struct NewDeclutterItemSheet: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var location = ""
    @State private var reason = ""
    @State private var action: DeclutterAction = .donate

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("新增斷捨離項目")
                    .font(AppTheme.headerFont)
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(AppTheme.primaryText)
                }
            }

            AuthTextField(placeholder: "物品名稱", text: $name)
            AuthTextField(placeholder: "位置，例如：衣櫃 / 掛衣區", text: $location)
            AuthTextField(placeholder: "原因，例如：很少使用", text: $reason)

            Picker("處理方式", selection: $action) {
                ForEach(DeclutterAction.allCases, id: \.self) { action in
                    Text(action.rawValue).tag(action)
                }
            }
            .pickerStyle(.segmented)

            PrimaryButton(
                title: "新增",
                action: save,
                isDisabled: name.trimmedForUserInput.isEmpty
            )

            Spacer()
        }
        .padding(24)
        .background(AppTheme.backgroundColor)
    }

    private func save() {
        viewModel.addDeclutterItem(name: name, locationText: location, action: action, reason: reason)
        isPresented = false
    }
}
