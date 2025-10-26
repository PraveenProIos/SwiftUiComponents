//
//  RLGLists.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini Yadav on 21/08/25.
//

    
import SwiftUI


public enum listBackgroundTheme {
    case defaultTheme
    case white
    case none
}

public struct oneRowData:  Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let subTitle: String
    public let labelTag: String?
    public let image: String?
    public let titleIcon: IconType?
    
    public init(withIcon titleIcon: IconType? = nil, title: String, subTitle: String, labelTag: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.titleIcon = titleIcon
        self.labelTag = labelTag
        self.image = nil
    }
    
    public init(withRowImage image: String?, title: String, subTitle: String, labelTag: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.titleIcon = nil
        self.labelTag = labelTag
        self.image = image
    }
}

public struct RLGLists: View {
    public var listTitle: String?
    public var listTheme: listBackgroundTheme
    public var rowImageSize: CGSize
    @Binding public var rowsData: [oneRowData]
    public var onTapRow: ((oneRowData) -> Void)?
    @Environment(\.colorScheme) var colorScheme

    public init(rowsData: Binding<[oneRowData]>, listTitle: String? = nil, listTheme: listBackgroundTheme = .none, rowImageSize: CGSize = CGSize(width: 74, height: 74), onTapRow: ((oneRowData) -> Void)?) {
        self.listTitle = listTitle
        self.listTheme = listTheme
        self.rowImageSize = rowImageSize
        self._rowsData = rowsData
        self.onTapRow =  onTapRow
    }

    public var body: some View {
        VStack(alignment: .leading) {
            LazyVStack {
                if let title = listTitle {
                    Text(title)
                        .modifier(ListTitle())
                        .padding(.top, CGFloat(StyleDictionarySize.spacing500))
                        .padding(.bottom, CGFloat(StyleDictionarySize.spacing300))
                        .accessibilityIdentifier("\(title)")
                }
                ForEach(rowsData) { item in
                    Divider()
                        .modifier(ListSeparator())
                    ListWithOneColumnView(item: item, imgSize: rowImageSize) {
                        if let onTap = onTapRow {
                            onTap(item)
                        }
                    }
                    .modifier(ListRowContentModifier())
                    .padding(.vertical, CGFloat(StyleDictionarySize.spacing200))
                }
            }
        }
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing300))
        .background(getListBackgroundThemeColor())
    }
    
   private func getListBackgroundThemeColor() -> Color {
       switch listTheme {
       case .none:
           Color.clear
       default:
           if colorScheme == .light {
               listTheme == .defaultTheme ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.lightNeutral0)
           } else {
               Color.clear
           }
       }
    }
}

struct ListWithOneColumnView: View {
    @Environment(\.colorScheme) var colorScheme
    let item: oneRowData
    let imgSize: CGSize
    var onTap: (() -> Void)? = nil
    var body: some View {
        Group {
            Button(action: {
                onTap?()
            }) {
                HStack(alignment: .top, spacing: CGFloat(StyleDictionarySize.spacingSpacing250)) {
                    if let rowTitleIcon = item.titleIcon {
                        ListRowHeaderIcon(icon: rowTitleIcon, iconColor: Color(StyleDictionaryColor.lightNeutral100))
                    }
                    else if let img = item.image {
                        AsyncImage(url: URL(string: img)) { image in
                            image
                                .resizable()
                        } placeholder: {
                            Image(colorScheme == .light ? ImageConstatnts.swanPlaceholder_Img : ImageConstatnts.swanPlaceholder_Img_white, bundle: .module)
                                .resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imgSize.width, height: imgSize.height)
                        .clipped()
                    }
                    VStack(alignment: .leading, spacing: CGFloat(StyleDictionarySize.spacing100)) {
                        if let tagLbl = item.labelTag, !tagLbl.isEmpty {
                            Text(tagLbl)
                                .modifier(ListLabelTag())
                        }
                        Text(item.title)
                            .modifier(ListRowTitle())
                        Text(item.subTitle)
                            .modifier(ListSupportingLabel())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("ListRow_\(item.title)")
            .accessibilityElement(children: .combine)
            .accessibilityLabel(makeAccessibilityLabel())
            .accessibilityAddTraits(.isButton)
            .accessibilityHint(StringConstants.accessbilityLbl_DoubleTapTo)
        }
    }

    private func makeAccessibilityLabel() -> Text {
        var label = Text("")

        if let tagLbl = item.labelTag, !tagLbl.isEmpty {
            label = label + Text(tagLbl.replacingOccurrences(of: "|", with: "").trimmingCharacters(in: .whitespacesAndNewlines) + ", ")
        }

        let cleanedTitle = item.title.replacingOccurrences(of: "|", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        label = label + Text(cleanedTitle + ", ")

        let cleanedSubtitle = item.subTitle.replacingOccurrences(of: "|", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        label = label + Text(cleanedSubtitle)

        return label
    }
}

#Preview {
    var rows: [oneRowData] = [oneRowData(withIcon: IconType.system(name: "star.fill"), title: "Title Small", subTitle: "Supporting text", labelTag: "LABEL"),
                              oneRowData(withIcon: IconType.packageImage("LabelIcon"), title: "Title Small", subTitle: "Supporting text")]
    var rowsWithImage: [oneRowData] = [oneRowData(withRowImage: "https://cdn.pixabay.com/photo/2025/05/04/18/04/robin-9578746_1280.jpg", title: "Title Small", subTitle: "Supporting text",labelTag: "LABEL"),
                                                      oneRowData(withRowImage: "", title: "Title Small", subTitle: "Supporting text", labelTag: "LABEL")]
    
    RLGLists(rowsData: .constant(rowsWithImage), listTitle: "Title", listTheme: .defaultTheme, rowImageSize: CGSize(width: 74, height: 74)) { item in
        print("Tapped on Row:- \(item)")
    }
}
