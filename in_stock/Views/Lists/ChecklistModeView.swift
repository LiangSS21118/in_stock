import SwiftUI

struct ChecklistModeView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Shopping Checklist Card
            PaperChecklistCard(title: "購物清單", dateString: "26/04/17", progressText: viewModel.shoppingProgress) {
                ForEach(viewModel.shoppingItems) { item in
                    ChecklistRow(title: item.name, isChecked: item.isChecked) {
                        viewModel.toggleShoppingItem(item.id)
                    }
                }
            }
            
            // Declutter Todo Card
            PaperChecklistCard(title: "斷捨離待辦", progressText: viewModel.declutterProgress) {
                ForEach(viewModel.declutterTodos) { item in
                    ChecklistRow(title: item.name, isChecked: item.isChecked) {
                        viewModel.toggleDeclutterTodo(item.id)
                    }
                }

                NavigationLink(destination: DeclutterView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "arrow.right.circle")
                        Text("查看斷捨離清單")
                        Spacer()
                    }
                    .font(AppTheme.captionFont.bold())
                    .foregroundColor(AppTheme.primaryText)
                    .padding(.top, 4)
                }
            }
            
            // Suggestions Sections
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "建議購入")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        SuggestionItemView(image: "🥛", name: "牛奶")
                        SuggestionItemView(image: "🥚", name: "雞蛋")
                        SuggestionItemView(image: "🧴", name: "洗髮精")
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "建議斷捨離")
                VStack(spacing: 12) {
                    SuggestionRow(name: "玄關備用傘", reason: "重複擁有")
                    SuggestionRow(name: "重複馬克杯", reason: "很少使用")
                    SuggestionRow(name: "久未使用毛巾", reason: "不再喜歡")
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ChecklistRow: View {
    let title: String
    let isChecked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .black : .gray)
                Text(title)
                    .font(AppTheme.bodyFont)
                    .strikethrough(isChecked)
                    .foregroundColor(isChecked ? .gray : .black)
                Spacer()
            }
        }
    }
}

struct SuggestionItemView: View {
    let image: String
    let name: String
    var body: some View {
        VStack(spacing: 8) {
            Text(image).font(.system(size: 30))
            Text(name).font(AppTheme.captionFont.bold())
        }
        .frame(width: 80, height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }
}

struct SuggestionRow: View {
    let name: String
    let reason: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(AppTheme.bodyFont.bold())
                Text(reason).font(AppTheme.captionFont).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "plus")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }
}
