//
//  RLGTilesView.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini yadav on 10/09/25.
//

import SwiftUI


public struct RLGTilesView: View {
    public var tilesStyle: TilesStyleType
    public var icon: IconType?
    public var title: String
    public var description: String?
    public var subTitle: String?
    public var cardImage: String?
    public var cornerRadiusStyle: NavigationalTilesCornerStyle
    public var cardPlaceholderImg: IconType?
    public var action: () -> Void
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .body) private var cardViewIconHeight = 24
    @ScaledMetric(relativeTo: .body) private var forwardArrowIconHeight = 24

    public init(actionTiles icon: IconType?, title: String, action: @escaping () -> Void) {
        self.tilesStyle = .tiles
        self.icon = icon
        self.title = title
        self.action = action
        self.description = nil
        self.subTitle = nil
        self.cardImage = nil
        self.cardPlaceholderImg = nil
        self.cornerRadiusStyle = .noCorners
    }
    
    public init(navigationalTile title: String, icon: IconType? = nil, description: String? = nil, subTitle: String? = nil, cardImage: String? = nil, cardPlaceholderImg: IconType? = nil, cornerRadiusStyle: NavigationalTilesCornerStyle, action: @escaping () -> Void) {
        self.tilesStyle = .cardView
        self.icon = icon
        self.title = title
        self.action = action
        self.description = description
        self.subTitle = subTitle
        self.cardImage = cardImage
        self.cardPlaceholderImg = cardPlaceholderImg
        self.cornerRadiusStyle = cornerRadiusStyle
    }
    
    public var body: some View {
        if tilesStyle == .tiles {
            // Tiles View
            tilesView()
        } else {
            // Card View
            cardView()
        }
    }
    
    @ViewBuilder
    private func IconView(for icon: IconType, size: CGFloat, isTiles: Bool = true) -> some View {
        let color = colorScheme == .light ? (isTiles ? Color(StyleDictionaryColor.secondary100) : Color(StyleDictionaryColor.primary100)) : Color(StyleDictionaryColor.darkNeutral100)
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .tileIconImageStyle(size: size, color: color)
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .tileIconImageStyle(size: size, color: color)
        }
    }
    
    @ViewBuilder
    private func tilesView() -> some View {
        let squareSize = CGFloat(StyleDictionarySize.spacing700) + CGFloat(StyleDictionarySize.spacing500)
        Button(action: action) {
            VStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                ZStack {
                    RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100), style: .continuous)
                        .fill(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral0) : Color(StyleDictionaryColor.darkNeutral10))
                        .frame(width: squareSize, height: squareSize)
                        .accessibilityHidden(true)
                    if let icon = icon {
                        IconView(for: icon, size: CGFloat(StyleDictionarySize.spacing700))
                            .accessibilityHidden(true)
                    }
                }
                Text(title)
                    .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeFootnote)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.vertical, 2)
                    .baselineOffset(2)
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle()) // Optional: remove default tap animation
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text(StringConstants.accessbilityLbl_DoubleTapTo))
    }
    
    private func cardView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Optional top image
            cardImageView()
            // Content container
            cardContentView()
        }
        .contentShape(Rectangle()) // Makes the whole HStack tapable
        .onTapGesture {
            action()
        }
        .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.darkNeutral30))
        .cornerRadius(style: cornerRadiusStyle)
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing400))
    }
    
    @ViewBuilder
    private func cardImageView() -> some View {
        if let img = cardImage {
            AsyncImage(url: URL(string: img)) { image in
                image
                    .resizable()
            } placeholder: {
                if let placeholderImg = cardPlaceholderImg {
                    cardViewPlacholderImage(placeholderImg: placeholderImg)
                }
            }
            .aspectRatio(1.56, contentMode: .fit)
            .frame(width: screenWidth-2*(CGFloat(StyleDictionarySize.spacing400)))
            .clipped()
            .accessibilityHidden(true)
        }
    }
    
    private func cardContentView() -> some View {
        HStack(alignment: .top, spacing: CGFloat(StyleDictionarySize.spacing100)) {
            cardTextContentView()
            Image(ImageConstatnts.vectorArrowIcon, bundle: .module)
                .tileIconImageStyle(size: forwardArrowIconHeight, color: (colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100)))
                .accessibilityHidden(true)
        }
        .padding(CGFloat(StyleDictionarySize.spacing300))
        // Accessibility for the interactive area only
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text((subTitle != nil ? ", \(subTitle!)" : StringConstants.emptyString) + title + (description != nil ? ", \(description!)" : StringConstants.emptyString)))
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("\(StringConstants.accessbilityLbl_DoubleTapTo)")
    }
    
    private func cardTextContentView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Optional icon
            if let icon = icon {
                IconView(for: icon, size: cardViewIconHeight, isTiles:  false)
                    .accessibilityHidden(true)
            }
            if let subTitle = subTitle, !subTitle.isEmpty {
                Text(subTitle)
                    .modifier(RLGTilesTextModifier(
                        color: colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral80) : Color(StyleDictionaryColor.darkNeutral100),
                        font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat( StyleDictionarySize.typographySizeCaption1)))
                    )
            }
            Text(title)
                .modifier(RLGTilesTextModifier(
                    color: colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100),
                    font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat( StyleDictionarySize.typographySizeCallout)))
                )
            if let description = description, !description.isEmpty {
                Text(description)
                    .modifier(RLGTilesTextModifier(
                        color: colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100),
                        font: Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeBodySmall)))
                    )
            }
        }
    }
    
    private func cardViewPlacholderImage(placeholderImg: IconType) -> some View {
        switch placeholderImg {
        case .system(let name):
            Image(systemName: name)
                .resizable()
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .resizable()
        }
    }
}

#Preview {
    VStack(spacing: 20){
        RLGTilesView(navigationalTile: "Title", icon: IconType.packageImage(ImageConstatnts.tabIcon) ,description: "Description", subTitle: "Subtitle", cardImage: ImageConstatnts.cardTilesImg, cardPlaceholderImg: IconType.packageImage(ImageConstatnts.cardTilesImg), cornerRadiusStyle: .topCorners) {
            print("Card tapped image ")
        }
        RLGTilesView(actionTiles: IconType.packageImage("TabIcon") , title: "Title") {
            // navigate or add functionality tap on any tiles
            print("Tile tapped")
        }
    }
    .padding()
    .background(Color.gray)
}
