//
//  RLGLink.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 03/07/25.
//

import SwiftUI


public enum LinkStyleType {
    case link
    case skipLink
}

public enum LinkSize {
    case small
    case medium
    case large
}

public enum LinkFontFamilyName {
    case PTSerif
    case Grot10
}

public struct RLGLink: View {
    public let text: String
    public var color: Color?
    public let url: URL?
    public let isErrorLink: Bool
    public var linkStyleType: LinkStyleType
    public var linkSize: LinkSize
    public var linkFontFamily: LinkFontFamilyName
    var iconConfig: IConConfig?
    public var skipLinkAction: () -> Void
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .footnote) private var linkIconImageHeight = 10
    
    public init(text: String, color: Color? = nil, url: URL?, isErrorLink: Bool = false, linkStyleType: LinkStyleType, linkSize: LinkSize, linkFontFamily: LinkFontFamilyName, iconConfig: IConConfig? = nil, skipLinkAction: @escaping () -> Void) {
        self.text = text
        self.url = url
        self.isErrorLink = isErrorLink
        self.linkStyleType = linkStyleType
        self.linkSize = linkSize
        self.linkFontFamily = linkFontFamily
        self.skipLinkAction = skipLinkAction
        self.iconConfig = iconConfig
        self.color = color
    }
    
    public var body: some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                if linkStyleType == .skipLink {
                    skipLinkAction()
                } else if let url = self.url {
                    openURL(url)
                }
            }
            .accessibilityElement()
            .accessibilityLabel(text)
            .accessibilityHint(StringConstants.accessbilityLbl_DoubleTapTo)
            .accessibilityAddTraits(.isLink)
    }
    
    @ViewBuilder
    private var content: some View {
        HStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
            if let iconConfig = self.iconConfig {
                if iconConfig.iconPosition == .left {
                    imageView(for: iconConfig.icon, isSystemIcon: iconConfig.isSystemIcon)
                        .foregroundStyle(getLinkColor())
                    setupLink()
                } else if iconConfig.iconPosition == .right {
                    setupLink()
                    imageView(for: iconConfig.icon, isSystemIcon: iconConfig.isSystemIcon)
                        .foregroundStyle(getLinkColor())
                } else {
                    imageView(for: iconConfig.icon, isSystemIcon: iconConfig.isSystemIcon)
                        .foregroundStyle(getLinkColor())
                    setupLink()
                    imageView(for: iconConfig.icon, isSystemIcon: iconConfig.isSystemIcon)
                        .foregroundStyle(getLinkColor())
                }
            } else {
                setupLink()
            }
        }
    }

    private func setupLink() -> some View {
        Text(text)
            .font(Font.custom(getLinkFontFamilyName, size: getLinkTextSize))
            .foregroundColor(getLinkColor())
            .lineLimit(nil)
            .underline()
            .baselineOffset(2)
    }

    private func imageView(for icon: String, isSystemIcon: Bool) -> some View {
            if isSystemIcon {
                return Image(systemName: icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: getLinkImageSize)
            } else {
                return Image(icon, bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: getLinkImageSize)
            }
     }
    
    private func getLinkColor() -> Color {
        if isErrorLink {
            return Color(StyleDictionaryColor.semanticDanger60)
        } else if let color = self.color {
           return color
        } else {
            return colorScheme == .light ?  Color(StyleDictionaryColor.secondary100) : Color(StyleDictionaryColor.darkNeutral100)
        }
    }
    
    private var getLinkFontFamilyName : String {
        switch linkFontFamily {
        case .PTSerif:
            return StyleDictionaryTypography.typographyFamilyBody
        case .Grot10:
            return StyleDictionaryTypography.typographyFamilyTitle
        }
    }
    
    private var getLinkTextSize : CGFloat {
        if linkStyleType == .link {
            switch linkSize {
            case .medium: return CGFloat(StyleDictionarySize.typographySizeBodyMedium)
            case .large: return CGFloat(StyleDictionarySize.typographySizeBodyLarge)
            default: return CGFloat(StyleDictionarySize.typographySizeBodySmall)
            }
        } else {
            return CGFloat(StyleDictionarySize.typographySizeBodyLarge)
        }
    }
    
    private var getLinkImageSize : CGFloat {
        if linkStyleType == .link {
            switch linkSize {
            case .large: return linkIconImageHeight+2
            default: return linkIconImageHeight
            }
        } else {
            return linkIconImageHeight+2
        }
    }
}

#Preview {
    VStack {
        RLGLink(text: "Link", url: URL(string: "https://google.com"), linkStyleType: LinkStyleType.link, linkSize: .large, linkFontFamily: .PTSerif, iconConfig: IConConfig(icon: ImageConstatnts.listIcon , isSystemIcon: false, iconPosition: .right), skipLinkAction: {})
        RLGLink(text: "Link", url: URL(string: "https://google.com"), isErrorLink: true, linkStyleType: LinkStyleType.link, linkSize: .large, linkFontFamily: .Grot10, iconConfig: IConConfig(icon: ImageConstatnts.listIcon , isSystemIcon: false, iconPosition: .left), skipLinkAction: {})
    }
}
