//
//  RLGCheckList.swift
//  RLGUIComponent
//
//  Created by Aparna Duddekunta on 11/06/25.
//

import SwiftUI

public struct Item: Identifiable {
    public let id = UUID()
    public var name: String
    public var isSelected: Bool = false
    public init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}

public class RLGChecklistViewModel: ObservableObject {
@Published public var items: [Item]
   public init(items: [Item]) {
        self.items = items
    }
    func toggleCheck(for item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isSelected.toggle()
        }
    }
    public var checkedItems: [Item] {
        items.filter { $0.isSelected }
    }
}
// Reusable ChecklistView component
public struct RLGCheckList: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RLGChecklistViewModel
    public init(viewModel: RLGChecklistViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        List {
            ForEach(viewModel.items) { item in
                ChecklistRow(
                    item: item,
                    colorScheme: colorScheme,
                    toggleAction: {
                        viewModel.toggleCheck(for: item)
                    }
                )
            }
        }
    }
    
    private struct ChecklistRow: View {
        var item: Item
        var colorScheme: ColorScheme
        var toggleAction: () -> Void

        var body: some View {
            HStack {
                Text(item.name)
                    .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCallout),relativeTo: .callout))
                
                Spacer()
                Button(action: toggleAction) {
                    if item.isSelected {
                        Image(systemName: "checkmark")
                    }
                }
                .accentColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral90): Color(StyleDictionaryColor.darkNeutral100))
            }
            .accessibilityIdentifier("RLGCheckList")
            .accessibilityElement(children: .combine)
            .accessibilityLabel(item.name)
            .accessibilityAddTraits(item.isSelected ? .isSelected : .isButton)
            .accessibilityHint(item.isSelected ?
                               "Double tap to deselect" :
                               "Double tap to select")
        }
    }
}
//MARK: Sample usage
struct ContentView2: View {
    @StateObject var viewModel = RLGChecklistViewModel(items: [
        Item(name: "Item 1", isSelected: false),
        Item(name: "Item 2", isSelected: true),
        Item(name: "Item 3", isSelected: false)
    ])
    var body: some View {
        NavigationView {
            RLGCheckList(viewModel: viewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Get Checked") {
                            print("Checked Items:")
                            for item in viewModel.checkedItems {
                                print(item.name)
                            }
                        }
                    }
                }
        }
    }
}
// Preview
#Preview {
    ContentView2()
}
