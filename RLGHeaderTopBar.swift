//
//  RLGHeaderTopBar.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini yadav on 13/09/25.
//

import SwiftUI

//MARK: NavigationBarConfig
public struct NavigationBarConfig {
    let title: String?
    let rightBtnImage: IconType?
    let leftBtnImage: IconType?
    let leftBtnTitle: String?
    let rightBtnAccessibilityLabel: String?
    let onLeftBtnTapped: (() -> Void)?
    let onRightBtnTapped: (() -> Void)?
    
    public init(title: String? = nil, rightBtnImage: IconType? = nil, leftBtnImage: IconType? = nil, leftBtnTitle: String? = nil, rightBtnAccessibilityLabel: String? = nil, onLeftBtnTapped: (() -> Void)? = nil, onRightBtnTapped: (() -> Void)? = nil) {
        self.title = title
        self.rightBtnImage = rightBtnImage
        self.leftBtnImage = leftBtnImage
        self.leftBtnTitle = leftBtnTitle
        self.rightBtnAccessibilityLabel = rightBtnAccessibilityLabel
        self.onLeftBtnTapped = onLeftBtnTapped
        self.onRightBtnTapped = onRightBtnTapped
    }
}

public struct RLGHeaderTopBar: View {
    public let promptMsg: String?
    public let heading: String?
    public let headingLblColor: Color?
    public let navBarConfig: NavigationBarConfig?
    @Environment(\.colorScheme) var colorScheme

    public init(promptMsg: String? = nil, heading: String? = nil, headingLblColor: Color? = nil, navBarConfig: NavigationBarConfig? = nil) {
        self.promptMsg = promptMsg
        self.heading = heading
        self.headingLblColor = headingLblColor
        self.navBarConfig = navBarConfig
    }
    
    public var body: some View {
        VStack(spacing: CGFloat(StyleDictionarySize.spacing100)) {
            // prompt message
            promptMessageView
            // Top Nav Bar
            navBarView
            // Optional Heading
            if let heading = heading {
                Text(heading)
                    .modifier(RLGTopBarTextModifier(fontSize: CGFloat(StyleDictionarySize.typographySizeDisplayLarge),
                                                    color: headingColor,
                                                    horizontalPadding: CGFloat(StyleDictionarySize.spacing300),
                                                    verticalPadding: CGFloat(StyleDictionarySize.spacing100),
                                                    txtAlignment: .leading))
                    .padding(.bottom, CGFloat(StyleDictionarySize.spacing100))
                    .accessibilityElement()
                    .accessibilityLabel(Text("\(heading), \(StringConstants.accessbilityLbl_Heading)"))
                    .accessibilitySortPriority(1)
            }
        }
        .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.darkNeutral0))
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder
    private func navIconView(for icon: IconType, size: CGFloat) -> some View {
        let color = colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100)
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
    private var navBarView: some View {
        if let navBar = navBarConfig {
            ZStack(alignment: .center) {
                navTitleView(navBar)
                HStack {
                    leftNavButton(navBar)
                    Spacer()
                    rightNavButton(navBar)
                }
            }
            .padding(10)
        }
    }

    
    @ViewBuilder
    private var promptMessageView: some View {
        if let prompt = promptMsg, !prompt.isEmpty {
            Text(prompt)
                .modifier(RLGTopBarTextModifier(fontSize: CGFloat(StyleDictionarySize.typographySizeFootnote),
                                                color: (colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100)),
                                                horizontalPadding: CGFloat(StyleDictionarySize.spacing300),
                                                verticalPadding: CGFloat(StyleDictionarySize.spacing100), txtAlignment: .center))
                .multilineTextAlignment(.center)
                .accessibilityLabel(prompt)
                .accessibilitySortPriority(5)
        }
    }
    
    @ViewBuilder
    private func navTitleView(_ navBar: NavigationBarConfig) -> some View {
        if let title = navBar.title, !title.isEmpty {
            Text(title)
                .modifier(RLGTopBarTextModifier(fontSize: CGFloat(StyleDictionarySize.typographySizeCallout),
                                                color: (colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100)),
                                                horizontalPadding: 3*CGFloat(StyleDictionarySize.spacing500),
                                                verticalPadding: CGFloat(StyleDictionarySize.spacing100), txtAlignment: .center))
                .multilineTextAlignment(.center)
                .accessibilityElement()
                .accessibilityLabel(Text("\(title), \(StringConstants.accessbilityLbl_Heading)"))
                .accessibilitySortPriority(3)
        }
    }

    @ViewBuilder
    private func leftNavButton(_ navBar: NavigationBarConfig) -> some View {
        if let img = navBar.leftBtnImage, let action = navBar.onLeftBtnTapped {
            Button(action: action) {
                HStack {
                    navIconView(for: img, size: CGFloat(StyleDictionarySize.spacing500))
                    if let title = navBar.leftBtnTitle, !title.isEmpty {
                        Text(title)
                            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeBodyMedium)))
                            .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100))
                    }
                }
            }
            .accessibilityElement()
            .accessibilityLabel(Text(navBar.leftBtnTitle ?? StringConstants.accessbilityLbl_LeftNavBtnAction))
            .accessibilityHint("\(StringConstants.accessbilityLbl_DoubleTapTo)")
            .accessibilityAddTraits(.isButton)
            .accessibilitySortPriority(4)
        }
    }

    @ViewBuilder
    private func rightNavButton(_ navBar: NavigationBarConfig) -> some View {
        if let img = navBar.rightBtnImage, let action = navBar.onRightBtnTapped {
            Button(action: action) {
                navIconView(for: img, size: CGFloat(StyleDictionarySize.spacing500))
                    .padding(.trailing, CGFloat(StyleDictionarySize.spacing100))
            }
            .accessibilityElement()
            .accessibilityLabel(navBar.rightBtnAccessibilityLabel ?? StringConstants.accessbilityLbl_RightNavDefaultAction)
            .accessibilityHint("\(StringConstants.accessbilityLbl_DoubleTapTo)")
            .accessibilityAddTraits(.isButton)
            .accessibilitySortPriority(2)
        }
    }
    
    private var headingColor: Color {
        if colorScheme != .light {
            return Color(StyleDictionaryColor.darkNeutral100)
        } else if let color = headingLblColor {
            return color
        } else {
            return Color(StyleDictionaryColor.lightNeutral100)
        }
    }
}

#Preview {
    VStack {
        RLGHeaderTopBar(promptMsg: "This is a prompt message.", heading: "Heading", headingLblColor: Color(StyleDictionaryColor.primary100), navBarConfig: NavigationBarConfig(title: "Title", rightBtnImage: IconType.packageImage(ImageConstatnts.tabIcon), leftBtnImage: IconType.packageImage(ImageConstatnts.backArrow), rightBtnAccessibilityLabel: "", onLeftBtnTapped: {
            print("left button tapped")
        }, onRightBtnTapped: {
            print("right button tapped")
        })
        )
        Spacer()
    }
}
