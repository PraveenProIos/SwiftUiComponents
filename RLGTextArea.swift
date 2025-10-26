//
//  RLGTextArea.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 28/06/25.
//


import SwiftUI

//MARK: RLGTextArea setup
public struct RLGTextArea: View {
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    var label: String?
    @Binding var text: String
    var hintText: String?
    var maxCharacters: Int?
    var errorMessage: String?
    var isDisabled: Bool = false
    
    public init(label:String? = nil,text: Binding<String>, hintText: String? = nil, maxCharacters: Int? = nil, errorMessage: String? = nil,isDisabled: Bool) {
        self.label = label
        self._text = text
        self.hintText = hintText
        self.maxCharacters = maxCharacters
        self.errorMessage = errorMessage
        self.isDisabled = isDisabled
    }
    public var body: some View {
        VStack(alignment: .leading) {
            if let label = label {
                setupLabel(label: label)
            }
            if let hintText = hintText  {
                setupHintText(hintText: hintText)
            }
            if let errorMessage = errorMessage {
                setupErrorMessage(errorMessage: errorMessage)
            }
            setupTextArea()
            HStack {
                if let maxCharacters = maxCharacters {
                    setupMaxCharacters(maxCharacters: maxCharacters)
                }
            }
        }.padding()
    }
    
    //MARK: Private methods
    private func setupLabel(label:String)-> some View {
        Text(label)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge),relativeTo: .body))
            .foregroundColor(setupLabelForegroundColor())
            .accessibilityIdentifier(isDisabled ? "RLGTextArea_Disabled_Label" : "RLGTextArea_Default_Label")

    }
    private func setupLabelForegroundColor() -> Color {
        if colorScheme == .light {
            return isDisabled ? Color(StyleDictionaryColor.lightNeutral80) : Color(StyleDictionaryColor.primary100)
        } else {
            return isDisabled ? Color(StyleDictionaryColor.lightNeutral60): Color(StyleDictionaryColor.darkNeutral100)
        }
    }
    private func setupHintText(hintText:String)-> some View {
        Text(hintText)
            .foregroundColor(colorScheme == .light ? .secondary : .white)
            .font(.subheadline)
            .accessibilityIdentifier(isDisabled ? "RLGTextArea_Disabled_Hint" : "RLGTextArea_Default_Hint")

    }

    private func setupErrorMessage(errorMessage:String)-> some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(Color(StyleDictionaryColor.semanticDanger60))
            Text(errorMessage)
                .foregroundColor(Color(StyleDictionaryColor.semanticDanger60))
                .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead),relativeTo: .subheadline))
                .accessibilityIdentifier(isDisabled ? "RLGTextArea_Disabled_Error" : "RLGTextArea_Default_Error")
            
        }
    }

    private func setupTextArea()-> some View {
        TextEditor(text: $text)
         .frame(minHeight: 48)
            .focused($isFocused)
            .fixedSize(horizontal: false , vertical: true)
            .foregroundStyle(setupTextForegroundColor())
            .background(setupTextAreaBackgroundColor())
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.secondary),
                alignment: .bottom
            )
            .disabled(isDisabled)
            .scrollContentBackground(.hidden)
    
            .toolbar() {
                ToolbarItem(
                    id: "",placement: .keyboard
               ) {
                   Button("Done") {
                       DispatchQueue.main.async {
                           isFocused = false
                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                       }
                   }
                }
            }
            .accessibilityIdentifier(isDisabled ? "RLGTextArea_Disabled" : "RLGTextArea_Default")

 }
    private func setupTextForegroundColor() -> Color {
        if colorScheme == .light {
            return isDisabled ? Color(StyleDictionaryColor.lightNeutral40) : Color(StyleDictionaryColor.lightNeutral100)
        } else {
            return isDisabled ? Color(StyleDictionaryColor.lightNeutral60): Color(StyleDictionaryColor.darkNeutral100)
        }
    }
    private func setupTextAreaBackgroundColor() -> Color {
        if colorScheme == .light {
            return isDisabled ? Color(StyleDictionaryColor.lightNeutral40) : Color(StyleDictionaryColor.darkNeutral100)
        } else {
            return isDisabled ? Color(StyleDictionaryColor.lightNeutral90) : Color(StyleDictionaryColor.lightNeutral90)
        }
    }

    private func setupMaxCharacters(maxCharacters:Int)-> some View {
        if text.count < maxCharacters {
            Text("\(maxCharacters - text.count) characters remaining")
                .foregroundColor(colorScheme == .light ? .secondary : .white)
                .font(.subheadline)
                .accessibilityIdentifier(isDisabled ? "RLGTextArea_Disabled_CharactersRemaining" : "RLGTextArea_Default_CharactersRemaining")

        } else {
            Text("\(text.count - maxCharacters) characters too many")
                .foregroundColor(.red)
                .font(.subheadline)
                .accessibilityIdentifier(isDisabled ? "RLGTextArea_Disabled_CharactersTooMany" : "RLGTextArea_Default_CharactersTooMany")
        }
    }
}

//MARK: PreviewProvider
struct ReusableTextArea_Previews: PreviewProvider {
    @State static var text = "Text Editor"
    static var previews: some View {
        RLGTextArea(label:"Label",text: $text, hintText: "Hint text", maxCharacters: 250, errorMessage: "Error message",isDisabled: false)
    }
}
