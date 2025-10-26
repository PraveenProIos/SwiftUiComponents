//
//  RLGBadge.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 30/06/25.
//

import SwiftUI


//MARK: Badge Theme configuration
public enum Theme: String, CaseIterable {
    case defaultTheme
    case inverted
    case info
    case success
    case warning
    case danger
  
    var color: Color {
        switch self {
        case .defaultTheme:
            return Color(StyleDictionaryColor.lightNeutral30)
        case .inverted:
            return Color(StyleDictionaryColor.lightNeutral80)
        case .info:
            return Color(StyleDictionaryColor.primary80)
        case .success:
            return Color(StyleDictionaryColor.semanticSuccess60)
        case .warning:
            return Color(StyleDictionaryColor.semanticWarning60)
        case .danger:
            return Color(StyleDictionaryColor.semanticDanger60)
        }
    }
}

//MARK: RLGBadge setup
public struct RLGBadge: View {
    public let theme: Theme
    public let text: String
    public var iconConfig: IConConfig?
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .caption) var iconHeight = 12
    public init(theme: Theme, text: String, iconConfig: IConConfig? = nil) {
        self.theme = theme
        self.text = text
        self.iconConfig = iconConfig
    }
    public var body: some View {
            HStack {
                if iconConfig != nil {
                    if iconConfig?.iconPosition == .left {
                        ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true, iconHeight: iconHeight)
                            .foregroundColor(setForegroundColor())
                        Text(text)
                            .accessibilityIdentifier(text)
                    } else {
                        Text(text)
                            .accessibilityIdentifier(text)
                        ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true, iconHeight: iconHeight)
                            .foregroundColor(setForegroundColor())
                    }
                } else {
                    Text(text)
                        .accessibilityIdentifier(text)
                }
            }.modifier(RLGBadgeStyle())
            .foregroundColor(setForegroundColor())
            .background(setBackgroundColor(customColor: theme.color))
            .cornerRadius(CGFloat(StyleDictionarySize.spacing100))
    }
    private func setForegroundColor() -> Color {
        switch theme {
        case .defaultTheme:
            colorScheme == .light ?  Color(StyleDictionaryColor.lightNeutral100): Color(StyleDictionaryColor.darkNeutral100)
        case .warning:
            Color(StyleDictionaryColor.lightNeutral100)
        default:
            Color(StyleDictionaryColor.darkNeutral100)
        }
    }
    private func setBackgroundColor(customColor: Color) -> Color {
        if colorScheme == .dark {
            if theme == .defaultTheme {
                return Color(StyleDictionaryColor.darkNeutral70)
            } else if theme == .info {
                return Color(StyleDictionaryColor.primary60)
            } else {
                return customColor
            }
        } else {
            return customColor
        }
    }
}

//MARK: RLGBadge ViewModifier
struct RLGBadgeStyle:ViewModifier {
    
func body (content:Content) -> some View {
        content
        .frame(minHeight: CGFloat(StyleDictionarySize.spacing400), alignment: .center)
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCaption1)))
        .lineLimit(nil)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.5)
        .accessibilityElement(children: .combine)
        .accessibilityRemoveTraits(.isSelected)
        .padding(.horizontal, 2*(CGFloat(StyleDictionarySize.spacing100)))
        .padding(.vertical, 2)
        .cornerRadius((CGFloat(StyleDictionarySize.spacing100)))
        .baselineOffset(2)
    }
}

#Preview {
    RLGBadge(theme: .defaultTheme, text: "Label", iconConfig: IConConfig(icon: ImageConstatnts.labelIcon, isSystemIcon: false, iconPosition: .right))

    RLGBadge(theme: .inverted, text: "Label", iconConfig: IConConfig(icon: ImageConstatnts.labelIcon, isSystemIcon: false, iconPosition: .right))
}
