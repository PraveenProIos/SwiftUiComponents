//
//  RLGProductiveCard.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 24/06/25.
//

import SwiftUI

public enum ProductiveCardStyle {
    case gradient
    case neutral
    case white
    case gradientAndNeutral
}
//MARK: ProductiveCardButtonConfig
public struct ProductiveCardButtonConfig {
    public var backgroundColor: Color
    public var actionTitle: String
    public var isDisabled: Bool = false
    public init(backgroundColor: Color, actionTitle: String, isDisabled: Bool) {
        self.backgroundColor = backgroundColor
        self.actionTitle = actionTitle
        self.isDisabled = isDisabled
    }
}

public struct title1AndSubtitle1Config {
    public var title1: String
    public var subTitle1: String
    public var title2: String?
    public var subTitle2: String?
    public init(title1: String, subTitle1: String, title2: String? = nil, subTitle2: String? = nil) {
        self.title1 = title1
        self.subTitle1 = subTitle1
        self.title2 = title2
        self.subTitle2 = subTitle2
    }
}

//MARK: ProductiveCardData
public struct ProductiveCardData: Identifiable {
    public let id = UUID()
    public var title: String
    public var label: String?
    public var subtitle: String?
    public var title1AndSubtitle1: title1AndSubtitle1Config?
    
    public init(title: String, label: String? = nil, subtitle: String? = nil, title1AndSubtitle1: title1AndSubtitle1Config? = nil) {
        self.title = title
        self.label = label
        self.subtitle = subtitle
        self.title1AndSubtitle1 = title1AndSubtitle1
    }
}

//MARK: RLGProductiveCard

public struct RLGProductiveCard: View {
    public  var cardStyle: ProductiveCardStyle
    public var cardData: ProductiveCardData
    public var link: RLGLink?
    public var isShowDividerLine: Bool
    public var isShowChevronRightArrow: Bool
    public var onTap: (() -> Void)? = nil // Optional tap action
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .body) private var chevronIconHeight = 20

    public init(cardStyle: ProductiveCardStyle, cardData: ProductiveCardData, link: RLGLink? = nil, isShowDividerLine: Bool, isShowChevronRightArrow: Bool, onTap: (() -> Void)? = nil) {
        self.cardStyle = cardStyle
        self.cardData = cardData
        self.link = link
        self.isShowDividerLine = isShowDividerLine
        self.isShowChevronRightArrow = isShowChevronRightArrow
        self.onTap = onTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing300)) {
            // Interactive Card
            if let tapAction = onTap, isShowChevronRightArrow {
                Button(action: tapAction) {
                    productCardContent
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                // Non-interactive Product Card
                productCardContent
            }
            if isShowDividerLine && cardStyle != .gradientAndNeutral {
                RLGDividerLine(styleType: cardStyle == .gradient ? .purple : .defautlStyle,
                               backgroundColor: .clear,
                               verticalPadding: 0,
                               horizontalPadding: (cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacingSpacing250) : 0)
                )
            }
            if let bottomContent = cardData.title1AndSubtitle1 {
                productCardBottomContent(bottomContent: bottomContent)
            }

            if let link = link {
                link
                    .padding(.horizontal, cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacingSpacing250) : 0)
                    .padding(.bottom, cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacing100) : 0)
            }
        }
        .padding(cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacing200) : CGFloat(StyleDictionarySize.spacing300))
        .background(backgroundMainView)
        .cornerRadius(CGFloat(StyleDictionarySize.spacing100))
    }

    // MARK: - Card Visual Content
    private var productCardContent: some View {
        HStack(alignment: (cardData.subtitle == nil && cardData.label == nil ) ? .center : .top, spacing: CGFloat(StyleDictionarySize.spacing200)) {
            VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing200)) {
                // Optional Label
                if let label = cardData.label, !label.isEmpty {
                    Text(label)
                        .modifier(RLGTilesTextModifier(
                            color: topTextColor,
                            font: Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyMedium)))
                        )
                        .accessibilityLabel("\(label)")
                }
                // Title
                Text(cardData.title)
                    .modifier(RLGTilesTextModifier(
                        color: topTextColor,
                        font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeDisplaySmall)))
                    )
                    .accessibilityLabel("\(cardData.title), \(StringConstants.accessbilityLbl_Heading)")
                    .accessibilityIdentifier("\(cardData.title)")
                              
                // Optional Subtitle
                if let subtitle = cardData.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .modifier(RLGTilesTextModifier(
                            color: subtitleColor,
                            font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCaption1)))
                        )
                        .accessibilityLabel("\(subtitle)")
                }
            }
            Spacer()
            // Chevron
            if isShowChevronRightArrow {
                iconView(for: IconType.packageImage(ImageConstatnts.vectorArrowIcon), size: chevronIconHeight)
                    .accessibilityHidden(true)
            }
        }
        .padding(cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacingSpacing250) : 0)
        .background(backgroundTopView)
        .cornerRadius(cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacing100) : 0)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(onTap != nil ? .isButton : .isStaticText)
        .accessibilityHint(onTap != nil ? StringConstants.accessbilityLbl_DoubleTapTo : StringConstants.emptyString)
    }
    
    private func productCardBottomContent(bottomContent: title1AndSubtitle1Config ) -> some View {
        HStack(alignment: .top, spacing: CGFloat(StyleDictionarySize.spacing200)) {
            VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing100)) {
                textView(text: bottomContent.subTitle1, size: CGFloat(StyleDictionarySize.typographySizeCaption1), color: subtitle1Color)
                    .accessibilityHidden(true)
                textView(text: bottomContent.title1, size: CGFloat(StyleDictionarySize.typographySizeCallout), color: title1Color)
                    .accessibilityLabel("\(bottomContent.subTitle1): \(bottomContent.title1)")
            }
            if let subtitle2 = bottomContent.subTitle2, let title2 = bottomContent.title2, !subtitle2.isEmpty, !title2.isEmpty {
                Spacer()
                VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing100)) {
                    textView(text: subtitle2, size: CGFloat(StyleDictionarySize.typographySizeCaption1), color: subtitle1Color)
                        .accessibilityHidden(true)
                    textView(text: title2, size: CGFloat(StyleDictionarySize.typographySizeCallout), color: title1Color)
                        .accessibilityLabel("\(subtitle2): \(title2)")
                }
            }
        }
        .padding(.horizontal, cardStyle == .gradientAndNeutral ? CGFloat(StyleDictionarySize.spacingSpacing250) : 0)
        .accessibilityElement(children: .combine)
    }
    
    @ViewBuilder
    private func iconView(for icon: IconType, size: CGFloat) -> some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .tileIconImageStyle(size: size, color: topTextColor)
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .tileIconImageStyle(size: size, color: topTextColor)
        }
    }
    
    private func textView(text: String, size: CGFloat, color: Color) -> some View {
        Text(text)
            .modifier(RLGTilesTextModifier(
                color: color,
                font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: size))
            )
    }
    
    // MARK: - Dynamic styling based on style
    var backgroundMainView: some View {
        switch cardStyle {
        case .gradient:
            return AnyView(
                LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.26, green: 0.04, blue: 0.26),
                                            Color(red: 0.63, green: 0.12, blue: 0.63)
                                           ]
                                  ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            )
        case .neutral, .gradientAndNeutral:
            return colorScheme == .light ? AnyView(Color(StyleDictionaryColor.lightNeutral20)) : AnyView(Color(StyleDictionaryColor.darkNeutral30))
        case .white:
            return colorScheme == .light ? AnyView(Color(StyleDictionaryColor.lightNeutral0)) : AnyView(Color(StyleDictionaryColor.darkNeutral30))
        }
    }
    
    var backgroundTopView: some View {
        switch cardStyle {
        case .gradientAndNeutral:
            return AnyView(
                LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.26, green: 0.04, blue: 0.26),
                                            Color(red: 0.63, green: 0.12, blue: 0.63)
                                           ]
                                  ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            )
        default:
            return AnyView(Color.clear)
        }
    }
    
    private var topTextColor: Color {
        (cardStyle == .gradient || cardStyle == .gradientAndNeutral || colorScheme != .light) ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.primary100)
    }

    private var subtitleColor: Color {
        (cardStyle == .gradient || cardStyle == .gradientAndNeutral || colorScheme != .light) ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.lightNeutral80)
    }
    private var subtitle1Color: Color {
        (cardStyle == .gradient || colorScheme != .light) ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.lightNeutral80)
    }
    
    private var title1Color: Color {
        (cardStyle == .gradient || colorScheme != .light) ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.primary100)
    }
}

#Preview {
        RLGProductiveCard(cardStyle: .neutral,
                          cardData: ProductiveCardData(title: "Title", label: "Label", subtitle: "Subtitle", title1AndSubtitle1: title1AndSubtitle1Config(title1: "Title1", subTitle1: "subtitle1", title2: "Title2", subTitle2: "Subtitle2")),
                          link: RLGLink(text: "Link",color: Color(StyleDictionaryColor.darkNeutral100), url: URL(string: "https://google.com"), linkStyleType: .link, linkSize: .medium , linkFontFamily: .PTSerif, iconConfig: IConConfig(icon: ImageConstatnts.listIcon , isSystemIcon: false, iconPosition: .right), skipLinkAction: {}),
                          isShowDividerLine: true, isShowChevronRightArrow: true, onTap: {
            print("tap on Card")
        })
}
