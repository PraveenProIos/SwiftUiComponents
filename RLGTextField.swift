//
//  RLGTextField.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini Yadav on 13/08/25.
//

import SwiftUI


// MARK: RLGTextFieldConfig
public struct TextFieldConfig {
    public let placeholder: String
    public var autoCompleteText: (_ textInput: String) -> Void
  
    public init(placeholder: String, autoCompleteText: @escaping (_ textInput: String) -> Void) {
        self.placeholder = placeholder
        self.autoCompleteText = autoCompleteText
    }
}

//MARK: RLGTextField setup
public struct RLGTextField: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory // Tracks device font size
    @FocusState private var isFocused: Bool
   
    // Calculate height dynamically based on font size
        private var dynamicHeight: CGFloat {
            let minHeight: CGFloat = 40
            switch sizeCategory {
            case .accessibilityExtraExtraExtraLarge:
                return max(minHeight, 54)
            case .accessibilityExtraExtraLarge:
                return max(minHeight, 50)
            case .accessibilityExtraLarge:
                return max(minHeight, 46)
            case .accessibilityLarge:
                return max(minHeight, 42)
            default:
                return minHeight
            }
        }
    
    // MARK: Public properities
    @Binding public var text: String
    @State public var showError: Bool = false
    public var labelText: String
    public var isShowErrorMsg: Bool
    public var errorMsg: String?
    public var isDisabled: Bool = false
    public var textField: TextFieldConfig
    public var prefixIconConfig: IConConfig?
    public var suffixIconConfig: IConConfig?
    public var styleType: TextFieldStyleType
    
    public init(labelText: String, isShowErrorMsg: Bool = false, errorMsg: String? = nil,
         text: Binding<String>, isDisabled: Bool,
         textField : TextFieldConfig,
         prefixIconConfig: IConConfig? = nil,
         suffixIconConfig: IConConfig? = nil,
         styleType: TextFieldStyleType) {
        
        self.labelText = labelText
        self.isShowErrorMsg = isShowErrorMsg
        self.errorMsg = errorMsg
        self._text = text
        self.isDisabled = isDisabled
        self.textField = textField
        self.prefixIconConfig = prefixIconConfig
        self.suffixIconConfig = suffixIconConfig
        self.styleType = styleType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(labelText)
                .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge)))
                .foregroundColor(getForegroundColor())
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .accessibilityLabel("\(labelText)")
           
            // Show Error Message
            if showError, !isDisabled, isShowErrorMsg {
                addErrorMessage()
            }
            HStack(spacing: 0) {
                // Prefix symbol
                if let prefix = prefixIconConfig, (styleType == .prefix || styleType == .prefixAndSuffix) {
                    addTextFieldPrefixSuffix(iconConfig: prefix )
                }
                // TextField
                addTextField()
              
                // Clear button
                if !text.isEmpty, !isDisabled {
                    addTextClearButton()
                }
                // Suffix image
                if let suffix = suffixIconConfig, (styleType == .suffix || styleType == .prefixAndSuffix) {
                    addTextFieldPrefixSuffix(iconConfig: suffix )
                }
            }
            .background(
                getTextFieldBackgroundColor()
            )
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(
                        isFocused ? Color(StyleDictionaryColor.secondary80) : Color(StyleDictionaryColor.lightNeutral40)
                    ),
                alignment: .bottom
            )
        }
        .padding()
    }
    
    private func getTextFieldBackgroundColor() -> Color {
        if colorScheme == .light {
            isDisabled ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.darkNeutral100)
        } else {
            isDisabled ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.lightNeutral90)
        }
    }
    
    private func getForegroundColor() -> Color {
        if isDisabled {
            Color(StyleDictionaryColor.lightNeutral40)
        } else {
            colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100)
        }
    }
    
    private func addErrorMessage() -> some View {
        HStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
            // Red Circle with Exclamation Mark
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(Color(StyleDictionaryColor.semanticDanger60))
                .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: 14))
                .accessibilityIdentifier("Error Icon")
            
            // Error Message Text
            Text(errorMsg ?? "")
                .foregroundColor(Color(StyleDictionaryColor.semanticDanger60))
                .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: 14))
                .accessibilityLabel("\(errorMsg ?? "")")
                .accessibilityIdentifier("Error Label")
        }
        .padding(.vertical, CGFloat(StyleDictionarySize.spacing100))
    }
    
    private func addTextFieldPrefixSuffix(iconConfig: IConConfig) -> some View {
        if iconConfig.isSystemIcon {
            Image(systemName: iconConfig.icon)
                .modifier(TextFieldPrefixSuffix(isDisabled: self.isDisabled, dynamicHeight: dynamicHeight))
                .accessibilityIdentifier(iconConfig.iconPosition == .left ? "prefixIcon" : "suffixIcon")
        } else {
            Image(iconConfig.icon, bundle: .module)
                .modifier(TextFieldPrefixSuffix(isDisabled: self.isDisabled, dynamicHeight: dynamicHeight))
                .accessibilityIdentifier(iconConfig.iconPosition == .left ? "prefixIcon" : "suffixIcon")
        }
    }
    
    private func addTextField() -> some View {
        TextField("", text: $text, prompt: Text(isFocused ? "Type here.." : textField.placeholder)
            .foregroundColor(
                (colorScheme == .light && !isDisabled) ? Color(StyleDictionaryColor.lightNeutral80) : Color(StyleDictionaryColor.lightNeutral40)
            )//, axis: .vertical
        )
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCallout)))
        .disabled(isDisabled)
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
        .frame(minHeight: dynamicHeight) // Match height with icons
        .focused($isFocused)
        .onChange(of: isFocused) { focused in
            showError = focused ? false : text.trimmingCharacters(in: .whitespaces).isEmpty
        }
        .onChange(of: text) {
            if isFocused {
                textField.autoCompleteText($0)
            }
        }
        .accessibilityLabel("\(labelText) input field")
        .accessibilityHint("Double tap to activate and type.")
        .accessibilityValue(text.isEmpty ? "" : "\(text)")
        .accessibilityIdentifier("RLGTextField") // ✅ For UI tests
    }
    
    private func addTextClearButton() -> some View {
        Button(action: {
            text = ""
            showError = text.isEmpty
        }) {
            Image(systemName: "xmark.circle.fill")
                .tint(colorScheme == .light ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.rlLightGrey100))
                .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.rlLightGrey60) : Color(StyleDictionaryColor.rlLightGrey40))
        }
        .padding(.trailing, CGFloat(StyleDictionarySize.spacingSpacing250))
        .accessibilityLabel("clear Text Button")
        .accessibilityHint("Double tap to activate")
        .accessibilityValue("Clear text field")
    }
}

#Preview {
    RLGTextField(labelText: "Label", isShowErrorMsg: true, errorMsg: "show error message here", text: .constant(""), isDisabled: false,
                 textField: TextFieldConfig(placeholder: "Placeholder text", autoCompleteText: { textInput in
        print("Text Typed: \(textInput)")
    }), prefixIconConfig:
                    IConConfig(icon: "sterlingsign", isSystemIcon: true, iconPosition: .left),
                 suffixIconConfig:
                    IConConfig(icon: "percent", isSystemIcon: true, iconPosition: .right),
                 styleType: .prefixAndSuffix)
}
