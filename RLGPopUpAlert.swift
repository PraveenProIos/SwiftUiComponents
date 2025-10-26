//
//  RLGPopUpAlert.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini Yadav on 25/07/25.
//

import SwiftUI


// MARK: ActionButtonConfig
public struct ActionButtonConfig {
    public let title: String
    public var isBtnEnable: Bool
    public var BtnAction: () -> Void
    public init(title: String, isBtnEnable: Bool, BtnAction: @escaping () -> Void) {
        self.title = title
        self.isBtnEnable = isBtnEnable
        self.BtnAction = BtnAction
    }
}

// MARK: TextFieldConfig
public struct popUpTextFieldConfig {
    public let placeholder: String
    public var autoCompleteText: (_ textInput: String) -> Void
  
    public init(placeholder: String, autoCompleteText: @escaping (_ textInput: String) -> Void) {
        self.placeholder = placeholder
        self.autoCompleteText = autoCompleteText
    }
}

public struct RLGPopUpAlert: View {
    @Environment(\.colorScheme) var colorScheme
    public var isPresented: Bool
    public var title: String
    public var message: String
    @State public var textInput: String
    public var textField: popUpTextFieldConfig?
    public var primaryButton: ActionButtonConfig?
    public var secondButton: ActionButtonConfig?
    public var thirdButton: ActionButtonConfig?
    
    public init(isPresented: Bool,
                title: String, message: String,
                textInput: String = StringConstants.emptyString,
                textField: popUpTextFieldConfig? = nil,
                primaryButton: ActionButtonConfig?,
                secondButton: ActionButtonConfig? = nil,
                thirdButton: ActionButtonConfig? = nil
    ) {
        self.isPresented = isPresented
        self.title = title
        self.message = message
        self.textInput = textInput
        self.textField = textField
        self.primaryButton = primaryButton
        self.secondButton = secondButton
        self.thirdButton = thirdButton
    }
    
    public  var body: some View {
        if isPresented {
            VStack {
                VStack(alignment: .center, spacing: CGFloat(StyleDictionarySize.spacing300)) {
                    setupTitle(label: title)
                    setupMessage(label: message)
                    if let txtField = textField {
                        setupTextField(placeholder: txtField.placeholder, autoCompleteText: txtField.autoCompleteText)
                            .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
                    }
                    setupSeperator()
                    if let primaryBtn = primaryButton, primaryBtn.isBtnEnable {
                        setupActionButton(title: primaryBtn.title, isPrimaryBtn: true, action: primaryBtn.BtnAction)
                    }
                    if let secondBtn = secondButton, secondBtn.isBtnEnable {
                        setupSeperator()
                        setupActionButton(title: secondBtn.title, action: secondBtn.BtnAction)
                    }
                    if let thirdBtn = thirdButton, thirdBtn.isBtnEnable {
                        setupSeperator()
                        setupActionButton(title: thirdBtn.title, action: thirdBtn.BtnAction)
                    }
                }
                .padding(.bottom, CGFloat(StyleDictionarySize.spacing300))
            }
            .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.darkNeutral20))
            .cornerRadius(CGFloat(StyleDictionarySize.spacing300))
            .padding(CGFloat(StyleDictionarySize.spacing200))
            .frame(width: UIDevice.current.localizedModel == "iPad" ? 420 : .infinity)
        }
    }
    
    private func setupTitle(label: String)-> some View {
        Text(title)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineMedium)).weight(.bold))
        .multilineTextAlignment(.center)
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, CGFloat(StyleDictionarySize.spacing300))
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
        .baselineOffset(2)
        .accessibilityIdentifier(StringConstants.rLGPopUpAlert_Title_Label)
        .accessibilityLabel(title+", \(StringConstants.accessbilityLbl_Heading)")
    }
    
    private func setupMessage(label: String)-> some View {
        Text(message)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodySmall)))
        .multilineTextAlignment(.center)
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, -CGFloat(StyleDictionarySize.spacing200))
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
        .baselineOffset(2)
        .accessibilityIdentifier(StringConstants.rLGPopUpAlert_Message_Label)
        .accessibilityLabel(message)
    }
    
    private func setupTextField(placeholder: String, autoCompleteText: @escaping (_ textInput: String) -> Void)-> some View {
        
        TextField(StringConstants.emptyString, text: $textInput, prompt: Text(placeholder)
            .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral40) : Color(StyleDictionaryColor.darkNeutral100)), axis: .vertical
        )
        .onChange(of: textInput) {
            print($0)
            autoCompleteText($0)
        }
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeFootnote)))
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing100))
        .padding(.vertical, CGFloat(StyleDictionarySize.spacing200))
        .cornerRadius(CGFloat(StyleDictionarySize.spacing100))
        .background(colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral40) : Color(StyleDictionaryColor.lightNeutral0))
        .overlay(
        RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100))
            .stroke((colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral40) : Color(StyleDictionaryColor.darkNeutral80)), lineWidth: 0.5)
        )
        .toolbar() {
            ToolbarItem(
                id: StringConstants.emptyString, placement: .keyboard
           ) {
               Button(StringConstants.done) {
                   DispatchQueue.main.async {
                       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                       autoCompleteText(textInput)
                   }
               }
            }
        }
        .accessibilityIdentifier(StringConstants.rLGPopUpAlertTextField)
        .accessibilityLabel("\(placeholder) \(StringConstants.inputField)")
        .accessibilityHint(StringConstants.rLGPopUpAlertActivateAndType)
    }
    
    private func setupActionButton(title: String, isPrimaryBtn: Bool = false, action: @escaping () -> Void)-> some View {
        let font = isPrimaryBtn ? Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeButtonText)).weight(.bold) :
        Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeButtonText))
      return Button(action: {
            action()
        }) {
            Text(title)
                .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.secondary80) : Color(StyleDictionaryColor.darkNeutral100))
                .font(font)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
                .baselineOffset(2)
        }
        .accessibilityLabel("\(title)")
        .accessibilityHint("\(StringConstants.accessbilityLbl_DoubleTapTo) \(title)")
        .accessibilityIdentifier("RLGPopUpAlert_\(title)")
        .accessibilityAddTraits(.isButton)
    }

    private func setupSeperator()-> some View {
        Divider()
            .frame(height: 0.5)
            .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral40) : Color(StyleDictionaryColor.darkNeutral80))
    }
}

#Preview() {
    RLGPopUpAlert(isPresented: true,
                  title: "Alert Title",
                  message: "Here’s some alert text. It can span multiple lines if needed!",
                  textField: popUpTextFieldConfig(placeholder: "Placeholder", autoCompleteText: { textInput in
        print("Enter Text Input: \(textInput)")
    }),
                  primaryButton: ActionButtonConfig(title: "Action", isBtnEnable: true, BtnAction: {
        print("primary button Tapped")
    }),
                  secondButton: ActionButtonConfig(title: "Action", isBtnEnable: true, BtnAction: {
        print("action button 2 Tapped")
    }),
                  thirdButton: ActionButtonConfig(title: "Action", isBtnEnable: true, BtnAction: {
        print("action button 3 Tapped")
    })
    )
}
