//
//  RLGRadioButton.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 04/07/25.
//

import SwiftUI

// MARK: - Model
public struct OptionItem: Identifiable, Equatable {
    public var id = UUID()
    public let title: String
    var isSelected: Bool = false
    public init(title: String) {
        self.title = title
    }
}
// MARK: - ViewModel
public class OptionsViewModel: ObservableObject {
    @Published var options: [OptionItem] = [
        OptionItem(title: "Label"),
        OptionItem(title: "Label"),
        OptionItem(title: "Label"),
        OptionItem(title: "Label")
    ]
    @Published var questionTitle: String?
    @Published var description: String?
    public init(options: [OptionItem], questionTitle: String, description: String) {
        self.options = options
        self.questionTitle = questionTitle
        self.description = description
    }
}
// MARK: - View
public struct RLGRadioButton: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: OptionsViewModel
    public init(viewModel: OptionsViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let questionTitle = viewModel.questionTitle {
                Text(questionTitle)
                    .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge),relativeTo: .body))
                    .foregroundStyle(colorScheme == .light ? Color(StyleDictionaryColor.primary100):Color(StyleDictionaryColor.darkNeutral100))
                    .bold()
            }
            VStack(spacing: 0) {
                ForEach($viewModel.options) { $option in
                    Button(action: {
                        select(option: option)
                    }
                    ) {
                        HStack {
                            Text(option.title)
                                .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCallout),relativeTo: .callout))
                                .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100):Color(StyleDictionaryColor.darkNeutral100))
                            Spacer()
                            if option.isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primary)
                                    .accessibilityIdentifier("Checkmark_\(option.title)")
                            }
                        }
                        .contentShape(Rectangle())
                        .padding()
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("Option_\(option.title)")
                    Divider()
                        .padding(.horizontal, 8)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            )
            if let description = viewModel.description {
                Text(description)
                    .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead),relativeTo: .body))
                    .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral80): Color(StyleDictionaryColor.darkNeutral40))
            }
        }
        .padding()
    }
    private func select(option: OptionItem) {
        for index in viewModel.options.indices {
            viewModel.options[index].isSelected = (viewModel.options[index].id == option.id)
        }
    }
}
