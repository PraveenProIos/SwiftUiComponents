//
//  RLGExpressiveCard.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 24/06/25.
//

import SwiftUI


// MARK: ExpressiveCardButton
public struct ExpressiveCardButton: View {
    @State private var navigate = false
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: Public properities
  //  public var cardColor: CardColors
    public var cardBackgroundColor: Color

    public var styleType: ButtonStyleType
    public var title: String
    public var isDisabled: Bool = false
    public var iconConfig: IConConfig?
    public let action: () -> Void

    public init(cardBackgroundColor: Color,
                styleType: ButtonStyleType,
                title: String,
                isDisabled: Bool,
                iconConfig: IConConfig? = nil,
                action: @escaping () -> Void) {
        
        self.cardBackgroundColor = cardBackgroundColor
        self.styleType = styleType
        self.title = title
        self.isDisabled = isDisabled
        self.iconConfig = iconConfig
        self.action = action
    }
    

    public var body: some View {
            Button(action: action) {
               content
                    .modifier(RLGButtonStyle(isRightAlignment: false))
                    .foregroundColor(getForegroundColor())
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(getCornerRadiusColor(),lineWidth: 2))
                    .padding(3)
                    .accessibilityLabel(title)
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to activate")
                    .accessibilityIdentifier(title)

            }
            .padding([.horizontal], 20)
            .disabled(isDisabled)
    }
    
    //MARK: - Private methods
    
    @ViewBuilder
    private var content: some View {
        HStack {
            if iconConfig != nil {
                if iconConfig?.iconPosition == .left {
                    ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true)
                    Text(title)
                } else {
                    Text(title)
                    ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true)
                }
            } else {
                Text(title)
            }
        }
    }

    private func getForegroundColor() -> Color {
        if cardBackgroundColor == Color(StyleDictionaryColor.primary100) || cardBackgroundColor == Color(StyleDictionaryColor.primary80) {
            return .white
        } else {
            return Color(StyleDictionaryColor.colourButtonTextGhost)

        }
        
    }

    private func getCornerRadiusColor() -> Color {
        if cardBackgroundColor == Color(StyleDictionaryColor.primary100) || cardBackgroundColor == Color(StyleDictionaryColor.primary80) {
            return .white
        } else {
            return Color(StyleDictionaryColor.colourButtonTextGhost)
        }
     }
    }

// MARK: LinkConfig
public struct LinkConfig {
    var linkTitle:String
    var linkAction: () -> Void

    public init(linkTitle: String, linkAction: @escaping () -> Void) {
        self.linkTitle = linkTitle
        self.linkAction = linkAction
    }
}

// MARK: LabelTagConfig
public struct LabelTagConfig {
    public var labelTag: String
    public var labelImage: String?
    public init(labelTag: String, labelImage: String? = nil) {
        self.labelTag = labelTag
        self.labelImage = labelImage
    }
}

// MARK: ActionConfig
public struct ActionConfig {
    public var styleType: ButtonStyleType
    public var actionTitle: String
    public var action: () -> Void
    public init(styleType: ButtonStyleType, actionTitle: String, action: @escaping () -> Void) {
        self.styleType = styleType
        self.actionTitle = actionTitle
        self.action = action
    }
   
}

// MARK: RLGExpressiveCard
public struct RLGExpressiveCard: View {
    var image: String?
    var subtitle: String?
    var labelTagConfig: LabelTagConfig?
    var title: String
    var description: String?
    var linkConfig:LinkConfig?
    var actionConfig:ActionConfig?
    var cardBackgroundColor: Color
    @StateObject var viewModel: CardViewModel = CardViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicSize

    public init(image: String? = nil, subtitle: String? = nil, labelTagConfig: LabelTagConfig? = nil, title: String, description: String? = nil, linkConfig: LinkConfig? = nil, actionConfig: ActionConfig? = nil, cardBackgroundColor: Color) {
        self.image = image
        self.subtitle = subtitle
        self.labelTagConfig = labelTagConfig
        self.title = title
        self.description = description
        self.linkConfig = linkConfig
        self.actionConfig = actionConfig
        self.cardBackgroundColor = cardBackgroundColor
    }
   
    public var body: some View {
        VStack(alignment: .leading) {
            if let image =  image {
                setupImage(image: image)
            }
            VStack(alignment: .leading,spacing: 20) {
                if let subtitle = subtitle {
                    setupSubTitle(subTitle: subtitle)
                }
                if let labelTagConfig = labelTagConfig {
                    setupLabelTag(labelTagConfig: labelTagConfig)
                }
                setupTitle(title: title)

                if let description = description {
                    setupDescription(description: description)
                }
                if let linkConfig = linkConfig {
                    setupLinkConfig(linkConfig: linkConfig)
                    
                }
            }.padding(.horizontal,20)
                .padding(.vertical)
            if let actionConfig = actionConfig {
                setupButtonconfig(actionConfig: actionConfig)

            }
        }.padding(.bottom)
        .frame(maxWidth: .infinity,alignment: .leading)
        .frame(maxHeight: .infinity)
        .task {
           let result =   viewModel.setupTheColorScheme(bgColor: cardBackgroundColor)
            print(result)
        }
        .background(setupCardBackgroundColor(bgColor: cardBackgroundColor))
        .padding(10)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    //Any private methods
    private func setupCardBackgroundColor(bgColor:Color) -> Color {
        if colorScheme == .dark && cardBackgroundColor == Color(StyleDictionaryColor.primary100) {
            return Color(StyleDictionaryColor.primary80)
        } else {
            return cardBackgroundColor
        }
    }
    private func setupImage(image:String) -> some View {
        Image(image,bundle: .module)
                .resizable()
                .frame(maxHeight: UIScreen.main.bounds.height/2)
    }
    private func setupSubTitle(subTitle:String) -> some View {
        Text(subTitle)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeFootnote),relativeTo: .callout))
            .foregroundStyle(viewModel.subTitleColor)
    }
    private func setupLabelTag(labelTagConfig:LabelTagConfig) -> some View {

            HStack {
                Text(labelTagConfig.labelTag)
                if let labelImage = labelTagConfig.labelImage {
                    Image(labelImage,bundle: .module)
                        .renderingMode(.template)          .resizable()
                        .frame(width: dynamicSize.isAccessibilitySize ? 36 : 18,height: dynamicSize.isAccessibilitySize ? 36 : 18)
                }
            }
            .foregroundStyle(viewModel.labelTagColor)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead),relativeTo: .callout))

                .padding(.horizontal,10)
                .background(Color.disabledDark)
    }
    private func setupTitle(title:String) -> some View {
        Text(title)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeDisplaySmall),relativeTo: .title3))
            .foregroundStyle(viewModel.titleColor)
    }
    private func setupDescription(description:String)-> some View {
        Text(description)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge),relativeTo: .body))
            .foregroundStyle(viewModel.descriptionColor)
    }
    private func setupLinkConfig(linkConfig:LinkConfig) -> some View {
        Button(action: linkConfig.linkAction) {
            Text(linkConfig.linkTitle)
                .underline()
                .foregroundStyle(viewModel.linkColor)
                .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge),relativeTo: .body))
        }
    }
    private func setupButtonconfig(actionConfig:ActionConfig)-> some View {
        ExpressiveCardButton(cardBackgroundColor: cardBackgroundColor, styleType: actionConfig.styleType, title: actionConfig.actionTitle, isDisabled: false, iconConfig: IConConfig(icon: ImageConstatnts.systemImageBell, isSystemIcon: true, iconPosition: .right), action: actionConfig.action)
    }
    
}

// MARK: Preview
#Preview {
    RLGExpressiveCard(image:"Man",
             subtitle: "Subtitle",
             labelTagConfig: LabelTagConfig(labelTag: "label",labelImage: ImageConstatnts.labelIcon),
             title: "Card title",
             description: "Description",
             linkConfig: LinkConfig(linkTitle: "Link", linkAction: {print("Link tapped")}),
             actionConfig: ActionConfig(styleType: .ghost, actionTitle: "Secondary Button ", action: {}),
                      cardBackgroundColor: Color(StyleDictionaryColor.primary100))

}

