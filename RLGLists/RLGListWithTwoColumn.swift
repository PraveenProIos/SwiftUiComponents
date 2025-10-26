//
//  RLGListWithTwoColumn.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini Yadav on 21/08/25.
//

    
import SwiftUI


public struct twoColumnRowData: Identifiable {
    public let id = UUID()
    public let label: String
    public let labelvalue: String
    public let iconImg: IconType?
    public init(label: String, labelValue: String, iconImg: IconType? = nil) {
        self.label = label
        self.labelvalue = labelValue
        self.iconImg = iconImg
    }
}

public struct RLGListWithTwoColumn: View {
    public var listTitle: String?
    public var listTheme: listBackgroundTheme
    public var headerLeft: String
    public var headerRight: String
    public var headerIcon: IconType?
    public var isShowHeader: Bool = false
    @Binding public var rowsData: [twoColumnRowData]
    @Environment(\.colorScheme) var colorScheme

    public init(rowsData: Binding<[twoColumnRowData]>, listTitle: String? = nil, headerIcon: IconType? = nil, headerLeft: String = "", headerRight: String = "", isShowHeader: Bool, listTheme: listBackgroundTheme = .defaultTheme) {
        self.listTitle = listTitle
        self.listTheme = listTheme
        self._rowsData = rowsData
        self.headerIcon = headerIcon
        self.headerLeft = headerLeft
        self.headerRight = headerRight
        self.isShowHeader = isShowHeader
    }
    
    public var body: some View {
        Group {
            VStack(alignment: .leading) {
                LazyVStack {
                    // Optional List Title
                    if let title = listTitle {
                        Text(title)
                            .modifier(ListTitle())
                    }
                    // Optional Header Row
                    if isShowHeader {
                        HStack {
                            HStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                                if let headerIcon = self.headerIcon {
                                    ListRowHeaderIcon(icon: headerIcon, iconColor: Color(StyleDictionaryColor.secondary100))
                                        .accessibilityHidden(true)
                                }
                                ListHeaderLabel(headerTitle: headerLeft)
                            }
                            Spacer()
                            ListHeaderLabel(headerTitle: headerRight)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.top, CGFloat(StyleDictionarySize.spacing200))
                        .modifier(ListRowContentModifier())
                    }
                    ForEach(rowsData) { item in
                        Divider()
                            .modifier(ListSeparator())
                        ListWithTwoColumnView(item: item)
                            .modifier(ListRowContentModifier())
                    }
                }
                .padding(.vertical, CGFloat(StyleDictionarySize.spacingSpacing250))
            }
            .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
            .background(getListBackgroundThemeColor())
        }
    }
    
    private func getListBackgroundThemeColor() -> Color {
        if colorScheme == .light {
            listTheme == .defaultTheme ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.lightNeutral0)
        } else {
            Color(StyleDictionaryColor.darkNeutral20)
        }
    }
}

struct ListWithTwoColumnView: View {
    let item: twoColumnRowData
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Group {
            HStack(spacing: 8) {
                if let rowTitleIcon = item.iconImg {
                    ListRowHeaderIcon(icon: rowTitleIcon, iconColor: Color(StyleDictionaryColor.secondary100))
                        .accessibilityHidden(true)
                }
                HStack {
                    Text(item.label)
                        .modifier(ListTwoColumnLabel())
                    Spacer()
                    Text(item.labelvalue)
                        .modifier(ListTwoColumnLabel())
                        .multilineTextAlignment(.trailing)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("\(item.label): \(item.labelvalue)"))
            }
        }
    }
}

struct ListRowHeaderIcon: View {
    let icon: IconType
    let iconColor: Color
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .largeTitle) private var listTitleIconImageHeight = 15
    
    var body: some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .tileIconImageStyle(size: listTitleIconImageHeight, color: colorScheme == .light ? iconColor :Color(StyleDictionaryColor.darkNeutral100))
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
                .tileIconImageStyle(size: listTitleIconImageHeight, color: colorScheme == .light ? iconColor :Color(StyleDictionaryColor.darkNeutral100))
        }
    }
}

struct ListHeaderLabel: View {
    let headerTitle: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text(headerTitle)
            .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineSmall)).weight(.bold))
            .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
    }
}

#Preview {
    var twoColumns: [twoColumnRowData] = [twoColumnRowData(label: "Label", labelValue: "input", iconImg: IconType.system(name: "star")),
                                          twoColumnRowData(label: "Label", labelValue: "Input", iconImg: IconType.packageImage( "LabelIcon")),
                                                         twoColumnRowData(label: "Label", labelValue: "Input", iconImg: IconType.packageImage("LabelIcon"))]
    RLGListWithTwoColumn(rowsData: .constant(twoColumns), listTitle: "Title", headerIcon: IconType.system(name: "star.fill"), headerLeft: "Header", headerRight: "Header", isShowHeader: true, listTheme: .defaultTheme)
}
