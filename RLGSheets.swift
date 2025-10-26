//
//  RLGSheets.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini yadav on 16/09/25.
//

import SwiftUI

import Foundation

public enum textAlignmentType {
    case left
    case center
}

public struct RLGSheets: View {
    public var title: String?
    public var subTitle: String?
    public var subTitle2: String?
    public var description: String?
    public var description2: String?
    public var imageUrl: String?
    public var primaryButtonTitle: String?
    public var textButtonTitle: String?
    public var isShowTopDragHandle: Bool
    public var isShowDismissButton: Bool
    public var isShowBottomButtons: Bool
    public var textAlignment: textAlignmentType
    public var dismissIconHeight: CGFloat
    public var primaryButtonAction: () -> Void
    public var textButtonAction: () -> Void

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var screenWidth: CGFloat = UIScreen.main.bounds.width

    public init(title: String? = nil, subTitle: String? = nil,
                subTitle2: String? = nil, description2: String? = nil,
                description: String? = nil, imageUrl: String? = nil,
                primaryButtonTitle: String? = nil, textButtonTitle: String? = nil,
                isShowTopDragHandle: Bool = true, isShowDismissButton: Bool = true,
                isShowBottomButtons: Bool = true, textAlignment: textAlignmentType = .center,
                dismissIconHeight: CGFloat = 30, primaryButtonAction: @escaping () -> Void,
                textButtonAction: @escaping () -> Void) {
        self.title = title
        self.subTitle = subTitle
        self.subTitle2 = subTitle2
        self.description = description
        self.description2 = description2
        self.imageUrl = imageUrl
        self.primaryButtonTitle = primaryButtonTitle
        self.textButtonTitle = textButtonTitle
        self.isShowTopDragHandle = isShowTopDragHandle
        self.isShowDismissButton = isShowDismissButton
        self.isShowBottomButtons = isShowBottomButtons
        self.textAlignment = textAlignment
        self.dismissIconHeight = dismissIconHeight
        self.primaryButtonAction = primaryButtonAction
        self.textButtonAction = textButtonAction
    }
    
    public var body: some View {
        VStack(spacing: isShowDismissButton ? 0 : CGFloat(StyleDictionarySize.spacing300) ) {
            // Drag Indicator
            if isShowTopDragHandle {
                Capsule()
                    .fill(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.darkNeutral80))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                    .accessibilityHidden(true)
            }
            // Close Button
            if isShowDismissButton {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        sheetImageView(img: colorScheme == .light ? IconType.packageImage(ImageConstatnts.dismissIcon) : IconType.packageImage(ImageConstatnts.dismissIconDark))
                            .scaledToFit()
                            .frame(width: dismissIconHeight, height: dismissIconHeight)
                    }
                    .padding(.top, isShowTopDragHandle ? 6 : CGFloat(StyleDictionarySize.spacing300))
                    .padding(.bottom, CGFloat(StyleDictionarySize.spacing200))
                    .accessibilityElement()
                    .accessibilityLabel(StringConstants.dismissSheet)
                    .accessibilityHint(StringConstants.accessbilityLbl_DoubleTapTo)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityIdentifier(StringConstants.dismissBtnIdentifier)
                }
            }
            ScrollView {
                // Title
                if let title = self.title, !title.isEmpty {
                    addTextView(text: title, font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeTitleLarge)),
                                txtColor: (colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100)), accessbilityLbl: StringConstants.accessbilityLbl_Heading)
                        .padding(.vertical, CGFloat(StyleDictionarySize.spacing200))
                        .accessibilityLabel("\(StringConstants.titleLblIdentifier), \(StringConstants.accessbilityLbl_Heading)")
                        .accessibilityIdentifier(StringConstants.titleLblIdentifier)
                }
                VStack(spacing: CGFloat(StyleDictionarySize.spacing500)) {
                    VStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                        // Subtitle
                        if let subTitle = self.subTitle, !subTitle.isEmpty {
                            addSubtitleAndDescription(text: subTitle, isSubtitle: true)
                        }
                        // Body Text
                        if let description = self.description, !description.isEmpty {
                            addSubtitleAndDescription(text: description, isSubtitle: false)
                        }
                    }
                    VStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                        // Subtitle
                        if let subTitle = self.subTitle2, !subTitle.isEmpty {
                            addSubtitleAndDescription(text: subTitle, isSubtitle: true)
                        }
                        // Body Text
                        if let description = self.description2, !description.isEmpty {
                            addSubtitleAndDescription(text: description, isSubtitle: false)
                        }
                    }
                }
                // Image Placeholder
                if let img = imageUrl {
                    AsyncImage(url: URL(string: img)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        sheetImageView(img: IconType.packageImage(ImageConstatnts.man))
                    }
                    .aspectRatio(1.04, contentMode: .fill)
                    .frame(width: screenWidth-2*(CGFloat(StyleDictionarySize.spacing300)))
                    .clipped()
                    .cornerRadius(CGFloat(StyleDictionarySize.spacing100))
                    .padding(.vertical, CGFloat(StyleDictionarySize.spacingSpacing250))
                    .accessibilityHidden(true)
                }
                VStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                    // Primary Button
                    if isShowBottomButtons {
                        if let btnTitle = primaryButtonTitle, !btnTitle.isEmpty {
                            addBottomButtonView(btnTitle: btnTitle, btnStyle: .primary, txtColor: Color(StyleDictionaryColor.lightNeutral0),
                                                btnBacgroundColor: colorScheme == .light ? Color(StyleDictionaryColor.secondary100) : Color(StyleDictionaryColor.secondary80),
                                                btnAction: primaryButtonAction)
                            .accessibilityIdentifier(StringConstants.primaryBtnIdentifier)
                        }
                        // Text Button
                        if let btnTitle = textButtonTitle, !btnTitle.isEmpty {
                            addBottomButtonView(btnTitle: btnTitle, btnStyle: .text,
                                                txtColor: (colorScheme == .light ? Color(StyleDictionaryColor.primary80) : Color(StyleDictionaryColor.darkNeutral100)),
                                                btnBacgroundColor: Color.clear,
                                                btnAction: textButtonAction)
                            .accessibilityIdentifier(StringConstants.textBtnIdentifier)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            Spacer()
        }
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
        .accessibilityElement(children: .contain)
    }
    
    private func sheetImageView(img: IconType) -> some View {
        switch img {
        case .system(let name):
            Image(systemName: name)
                .resizable()
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .resizable()
        }
    }
    @ViewBuilder
    private func addSubtitleAndDescription(text: String, isSubtitle: Bool) -> some View {
        if isSubtitle {
            addTextView(text: text, font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeTitleSmall)),
                        txtColor: (colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100)), accessbilityLbl: StringConstants.accessbilityLbl_Heading)
            .accessibilityLabel("\(StringConstants.subTitleLblIdentifier), \(StringConstants.accessbilityLbl_Heading)")
        } else {
            if text.isValidHTML(), let (attrStr, plainText) = getHTMLAttributedString(from: text) {
                Text(attrStr)
                    .frame(maxWidth: .infinity, alignment: textAlignment == .center ? .center : .topLeading)
                    .multilineTextAlignment(textAlignment == .center ? .center : .leading)
                    .accessibilityLabel(plainText)
                    .accessibilityIdentifier(StringConstants.descriptionLblIdentifier)
            } else {
                addTextView(text: text, font: Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyMedium)),
                            txtColor: (colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100)), accessbilityLbl: StringConstants.emptyString)
                .accessibilityIdentifier(StringConstants.descriptionLblIdentifier)
            }
        }
    }
    
    @ViewBuilder
    private func addBottomButtonView(btnTitle:String, btnStyle: ButtonStyleType, txtColor: Color, btnBacgroundColor: Color, btnAction: @escaping () -> Void) -> some View {
        RLGButton(styleType: btnStyle, title: btnTitle, isFocused: .constant(false), isDisabled: false, horizontalPadding: 0, action:  btnAction)
    }
    
    private func addTextView(text: String, font: Font, txtColor: Color, accessbilityLbl: String) -> some View {
        Text(text)
            .font(font)
            .foregroundColor(txtColor)
            .frame(maxWidth: .infinity, alignment: textAlignment == .center ? .center : .topLeading)
            .multilineTextAlignment(textAlignment == .center ? .center : .leading)
            .accessibilityLabel("\(text),\(accessbilityLbl)")
    }
    
    private func getHTMLAttributedString(from html: String) -> (AttributedString, String)? {
        if let data = html.data(using: .utf8),
           let nsAttrStr = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
           ) {
            var attrStr = AttributedString(nsAttrStr)
            // Customize font and color for the entire html string
            attrStr.foregroundColor = colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100)
            return (attrStr, nsAttrStr.string)
        } else {
           return nil
        }
    }
}

#Preview {
    RLGSheets(title: "Title",
              subTitle: "Here’s a subtitle",
              description: "The content goes here and will span a few sentences.",
              imageUrl: "", primaryButtonTitle: "Primary button", textButtonTitle: "Text Button", textAlignment: .left) {
        // primary Button Action
        print("primary button tapped")
    } textButtonAction: {
        // textButton Action
        print("text button tapped")
    }
}
