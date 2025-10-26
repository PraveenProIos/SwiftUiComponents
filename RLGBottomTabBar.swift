//
//  RLGBottomTabBar.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini Yadav on 5/09/25.
//

import SwiftUI
public struct TabItemModel: Identifiable, Hashable, Equatable {
    
    public static func == (lhs: TabItemModel, rhs: TabItemModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id = UUID()
    public let title: String
    public let icon: IconType

    public init(title: String, icon: IconType) {
        self.title = title
        self.icon = icon
    }
}

public struct RLGCustomTabBar: View {
    public let tabs: [TabItemModel]
    public let selectedColor: Color?
    public let unselectedColor: Color?
    public var badges: [Int: Int] // e.g.index: badgeCount
    public var badgesBackgroundColor: Color?
    public var badgeCountColor: Color?
    public let strokeLineHeight: CGFloat = 2
    private var tabIconHeight: CGFloat = 40
    @Binding public var selectedIndex: Int
    @Environment(\.colorScheme) var colorScheme

    public init(tabs: [TabItemModel], selectedIndex: Binding<Int>, badges: [Int: Int] = [:] ,selectedColor: Color? = nil, unselectedColor: Color? = nil, badgesBackgroundColor: Color? = nil, badgeCountColor: Color? = nil) {
        self.tabs = tabs
        self._selectedIndex = selectedIndex
        self.badges = badges
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.badgesBackgroundColor = badgesBackgroundColor
        self.badgeCountColor = badgeCountColor
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: strokeLineHeight)
                .background(getStrokeFillColor())
                .padding(.bottom, 0)
            // Tab Items
            HStack(alignment: .top, spacing: CGFloat(StyleDictionarySize.spacing300)) {
                ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                    Button(action: {
                        selectedIndex = index
                    }) {
                        VStack(alignment: .center, spacing: 0) {
                            if selectedIndex == index {
                                // Indicator line only for selected tab
                                Rectangle()
                                    .fill(getSelectedTabColor())
                                    .frame(height: strokeLineHeight)
                                    .offset(y: -6)
                                    .padding(.horizontal, CGFloat(StyleDictionarySize.spacing100))
                            } else {
                                // To keep spacing aligned
                                Color.clear.frame(height: strokeLineHeight)
                            }
                            
                            ZStack(alignment: .topTrailing) {
                                VStack(spacing: 0) {
                                    tabIconView(for: tab.icon, index: index)
                                    Text(tab.title)
                                        .font(getTitleFont(index: index))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(selectedIndex == index ? getSelectedTabColor() : getUnSelectedTabColor())
                                        .baselineOffset(2)
                                }
                                if !badges.isEmpty, let badgeCount = badges[index], badgeCount > 0 {
                                    badgeView(count: badgeCount)
                                        .offset(x: 12, y: -6)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    //Accessibility
                    .accessibilityElement()
                    .accessibilityLabel(Text(accessibilityLabel(for: tab, at: index)))
                    .accessibilityAddTraits(getAccessibilityTraits(for: index))
                    .accessibilityHint(selectedIndex != index ? StringConstants.accessbilityLbl_DoubleTapTo : "")
                    .accessibilityIdentifier("Tab_\(index)")
                }
            }
            .padding(.horizontal, 2*(CGFloat(StyleDictionarySize.spacing100)))
            .padding(.vertical, CGFloat(StyleDictionarySize.spacing100))
            .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral0) : Color(StyleDictionaryColor.darkNeutral0))
        }
    }

    private func accessibilityLabel(for tabItem: TabItemModel, at index: Int) -> String {
        let position = "\(index + 1) of \(tabs.count)"
        let selection = selectedIndex == index ? StringConstants.selectedString : StringConstants.emptyString
        var badgeStr = StringConstants.emptyString
        if !badges.isEmpty, let badgeCount = badges[index] {
            badgeStr = badgeCount == 0 ? StringConstants.emptyString : "\(badgeCount) \(StringConstants.newString) \(badgeCount == 1 ? StringConstants.itemString : StringConstants.itemsString)"
        }
        var components = [tabItem.title, StringConstants.tabString, position, badgeStr]
        components = components.filter { !$0.isEmpty }
        return components.joined(separator: ", ")
    }
    
    private func getAccessibilityTraits(for index: Int) -> AccessibilityTraits {
        let isSelected = selectedIndex == index
        if #available(iOS 17.0, *) {
            return isSelected ? [.isSelected, .isTabBar] : .isTabBar
        } else {
            return isSelected ? [.isSelected, .isButton] : .isButton
        }
    }
    
    private func getStrokeFillColor() -> Color {
        colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.darkNeutral40)
    }
    
    private func getTitleFont(index: Int) -> Font {
        if selectedIndex == index {
            Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCaption1)).weight(.bold)
        } else {
            Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCaption1))
        }
    }
    
    private func getSelectedTabColor() -> Color {
        if let selectedColor = self.selectedColor {
            selectedColor
        } else {
            colorScheme == .light ? Color(StyleDictionaryColor.secondary80) : Color(StyleDictionaryColor.secondary60)
        }
    }
    
    private func getUnSelectedTabColor() -> Color {
        if let unselectedColor = self.unselectedColor {
            unselectedColor
        } else {
            colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral70) : Color(StyleDictionaryColor.lightNeutral0)
        }
    }
    
    private func getBadgeCountColor() -> Color {
        if let color = self.badgeCountColor {
            color
        } else {
            Color(StyleDictionaryColor.lightNeutral0)
        }
    }
    
    private func getBadgeBackgroundColor() -> Color {
        if let color = self.badgesBackgroundColor {
            color
        } else {
            colorScheme == .light ? Color(StyleDictionaryColor.secondary80) : Color(StyleDictionaryColor.secondary60)
        }
    }
    
    @ViewBuilder
    private func tabIconView(for icon: IconType, index: Int) -> some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .renderingMode(.template)
                .foregroundColor(selectedIndex == index ? getSelectedTabColor() : getUnSelectedTabColor())
                .scaledToFit()
                .frame(width: tabIconHeight, height: tabIconHeight)
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .renderingMode(.template)
                .foregroundColor(selectedIndex == index ? getSelectedTabColor() : getUnSelectedTabColor())
                .scaledToFit()
                .frame(width: tabIconHeight, height: tabIconHeight)
        }
    }
    
    @ViewBuilder
    private func badgeView(count: Int) -> some View {
        Text(count > 99 ? "99+" : "\(count)")
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCaption2)).weight(.bold))
            .foregroundColor(getBadgeCountColor())
            .padding(CGFloat(StyleDictionarySize.spacing100))
            .background(Circle().fill(getBadgeBackgroundColor()))
            .frame(minWidth: CGFloat(StyleDictionarySize.spacing500), minHeight: CGFloat(StyleDictionarySize.spacing500))
    }
}
#Preview {
    let tabs: [TabItemModel] = [
        TabItemModel(title: "Home", icon: IconType.packageImage("TabIcon")),
        TabItemModel(title: "Wellbeing", icon: IconType.packageImage("TabIcon")),
        TabItemModel(title: "Articles", icon: IconType.packageImage("TabIcon")),
        TabItemModel(title: "Tools", icon: IconType.packageImage("TabIcon")),
        TabItemModel(title: "Account", icon: IconType.packageImage("TabIcon"))
    ]
    RLGCustomTabBar(tabs: tabs, selectedIndex: .constant(2))
}
