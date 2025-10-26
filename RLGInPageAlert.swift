//
//  RLGInPageAlert.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 08/07/25.
//

import SwiftUI

public enum InPageAlertType {
    case info, success, warning, danger
}
public enum InPageAlertBackgroundType {
    case defaultInPage, white
}
public struct RLGInPageAlertView: View {
    let iconConfig: IconType?
    let title: String?
    let message: String
    let link: RLGLink?
    let inPageAlertType: InPageAlertType
    let backgroundTheme: InPageAlertBackgroundType
    @ScaledMetric(relativeTo: .body) private var iconImageHeight = 20
    @Environment(\.colorScheme) var colorScheme

    public init(iconConfig: IconType?, title: String? = nil, message: String, link: RLGLink? = nil, inPageAlertType: InPageAlertType, backgroundTheme: InPageAlertBackgroundType = .defaultInPage) {
        self.iconConfig = iconConfig
        self.title = title
        self.message = message
        self.link = link
        self.inPageAlertType = inPageAlertType
        self.backgroundTheme = backgroundTheme
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .top, spacing: CGFloat(StyleDictionarySize.spacing200)) {
                if let icon = iconConfig {
                    imageView(for: icon)
                        .accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing200)) {
                    if let title = self.title , !title.isEmpty {
                        addTitleAndMessageLabel(title: title, font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineMedium),relativeTo: .headline).bold())
                    }
                    addTitleAndMessageLabel(title: message, font:Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyMedium)))
                    if let link = link {
                        link
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(CGFloat(StyleDictionarySize.spacing300))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(combinedAccessibilityLabel())
            .accessibilityAddTraits(.isStaticText)
            .accessibilityIdentifier(StringConstants.rlgInPageAlert)
        }
        .frame(maxWidth: .infinity) 
        .background(
            RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100))
                .fill(getbackgroundColor())
        )
        .overlay(
            RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100))
                .stroke(getInPageAlertTypeColor(), lineWidth: 2 )
        )
    }
    
    private func getbackgroundColor() -> Color {
        if colorScheme != .light {
            return Color(StyleDictionaryColor.darkNeutral20)
        } else {
            return backgroundTheme == .white ? Color(StyleDictionaryColor.lightNeutral0) : Color(StyleDictionaryColor.lightNeutral20)
        }
    }
    
    private func getInPageAlertTypeColor() -> Color {
        switch inPageAlertType {
        case .info:
            Color(StyleDictionaryColor.rlPurple60)
        case .success:
            Color(StyleDictionaryColor.semanticSuccess60)
        case .warning:
            Color(StyleDictionaryColor.rlWarning60)
        case .danger:
            Color(StyleDictionaryColor.rlDanger60)
        }
    }

    private func imageView(for icon: IconType) -> some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .tileIconImageStyle(size: iconImageHeight)
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .tileIconImageStyle(size: iconImageHeight)
        }
    }
    
    private func addTitleAndMessageLabel(title: String, font: Font) -> some View {
        Text(title)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .font(font)
            .foregroundStyle(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
            .multilineTextAlignment(.leading)
            .baselineOffset(2)
    }
    
    private func combinedAccessibilityLabel() -> String {
        let alertTypePrefix: String
        switch inPageAlertType {
        case .info:
            alertTypePrefix = StringConstants.informationLabel
        case .success:
            alertTypePrefix = StringConstants.successLabel
        case .warning:
            alertTypePrefix = StringConstants.warningLabel
        case .danger:
            alertTypePrefix = StringConstants.dangerLabel
        }

        if let title = title, !title.isEmpty {
            return "\(alertTypePrefix): \(title), \(StringConstants.accessbilityLbl_Heading). \(message)"
        }
        return "\(alertTypePrefix): \(message)"
    }
    
    private func announceIfNeeded() {
        // Only announce for critical alert types
        guard inPageAlertType == .danger || inPageAlertType == .warning else { return }

        let fullMessage = combinedAccessibilityLabel()
        UIAccessibility.post(notification: .announcement, argument: fullMessage)
    }
}

#Preview {
    RLGInPageAlertView(iconConfig: IconType.packageImage(ImageConstatnts.infoInPageAlert), title: "Title text goes here",  message: "New nominations will replace all your existing beneficiaries when you submit them and will be paid by discretion.",
                       link: RLGLink(text: "Link", url: URL(string: "https://www.google.com"), linkStyleType: .link, linkSize: .medium , linkFontFamily: .PTSerif, skipLinkAction: {}),
                       inPageAlertType: .info, backgroundTheme: .white)
}
