//
//  RLGCalloutCards.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini yadav on 25/09/25.
//

import SwiftUI


public struct RLGCalloutCards: View {
    public var icon: IconType?
    public var title: String?
    public var subtitle: String?
    public var description: String?
    public var isShowBorderLine: Bool
    public var isShowChevronRightArrow: Bool
    public var onTap: (() -> Void)? = nil // Optional tap action
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .body) private var iconHeight = 32
    @ScaledMetric(relativeTo: .body) private var chevronIconHeight = 24
    
    public init(icon: IconType? = nil, title: String? = nil, subtitle: String? = nil, description: String? = nil, isShowBorderLine: Bool = true,isShowChevronRightArrow: Bool = false, onTap: (()-> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.onTap = onTap
        self.isShowBorderLine = isShowBorderLine
        self.isShowChevronRightArrow = isShowChevronRightArrow
    }
    
    public var body: some View {
        Group {
            if let onTap = onTap {
                // Interactive Call Card (Button)
                Button(action: onTap) {
                    callCardContent
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle()) // Keeps styling intact
                .accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilitySummary)
                .accessibilityHint(StringConstants.accessbilityLbl_DoubleTapTo)
                .accessibilityAddTraits(.isButton)
            } else {
                // Non-interactive Call Card (Group)
                callCardContent
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(accessibilitySummary)
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100))
                .fill(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral0) : Color(StyleDictionaryColor.darkNeutral20))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100))
                .stroke(getCardsColor(), lineWidth: isShowBorderLine ? 1 : 0) // Border
        )
    }
    
    // MARK: - Card Visual Content
    private var callCardContent: some View {
        HStack(alignment: .top, spacing: CGFloat(StyleDictionarySize.spacing200)) {
            // Optional Icon
            if let icon = icon {
                iconView(for: icon, size: iconHeight)
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing200)) {
                // Optional Title
                if let title = title, !title.isEmpty {
                    Text(title)
                        .modifier(RLGTilesTextModifier(
                            color: getCardsColor(),
                            font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineMedium))
                                .weight(.bold))
                        )
                        .accessibilityHidden(true)
                }
                // Optional Subtitle
                if let subtitle = subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .modifier(RLGTilesTextModifier(
                            color: getCardsColor(),
                            font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead)))
                        )
                        .accessibilityHidden(true)
                }
                // Optional Description
                if let description = description, !description.isEmpty {
                    Text(description)
                        .modifier(RLGTilesTextModifier(
                            color: getCardsColor(),
                            font: Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyMedium)))
                        )
                        .accessibilityHidden(true)
                }
            }
            Spacer()
            // Chevron
            if isShowChevronRightArrow {
                iconView(for: IconType.packageImage(ImageConstatnts.vectorArrowIcon), size: chevronIconHeight)
                    .accessibilityHidden(true)
            }
        }
        .padding(CGFloat(StyleDictionarySize.spacingSpacing250))
    }
    private func getCardsColor() -> Color {
        colorScheme == .light ? Color(StyleDictionaryColor.secondary100) : Color(StyleDictionaryColor.darkNeutral100)
    }
    
    // MARK: - Combined Accessibility Summary
    private var accessibilitySummary: String {
        var components: [String] = []
        if let title = title {
            components.append(title)
        }
        if let subtitle = subtitle {
            components.append(subtitle)
        }
        if let description = description {
            components.append(description)
        }
        return components.joined(separator: StringConstants.joinSeperatorString)
    }
    
    @ViewBuilder
    private func iconView(for icon: IconType, size: CGFloat) -> some View {
        let color = colorScheme == .light ? Color(StyleDictionaryColor.secondary100) : Color(StyleDictionaryColor.darkNeutral100)
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .tileIconImageStyle(size: size, color: color)
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .tileIconImageStyle(size: size, color: color)
        }
    }
}

#Preview {
    RLGCalloutCards(
        icon: IconType.packageImage(ImageConstatnts.tabIcon),
        title: "Title",
        subtitle: "Supporting text",
        description: "Description",
        isShowChevronRightArrow: true, onTap: {
            print("Tapped on Call card")
        }
    )
    .padding()
}
