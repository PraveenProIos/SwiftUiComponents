//
//  ViewModifiers.swift
//  RLGUIComponents
//
//  Created by Aparna Duddekunta on 08/05/25.
//
import SwiftUI


//MARK: Setup dynamic image
struct ImageViewIcon:View {
    let icon: String
    let isSystemIcon: Bool
    let iconHeight: CGFloat

    init(icon: String, isSystemIcon: Bool, iconHeight: CGFloat = 12) {
        self.icon = icon
        self.isSystemIcon = isSystemIcon
        self.iconHeight = iconHeight
    }
    var body: some View {
        if isSystemIcon {
              Image(systemName: icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: iconHeight,height: iconHeight)
        } else {
            Image(icon,bundle: .module)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: iconHeight,height: iconHeight)
        }
    }
}

//MARK: RLGButton Viewmodifier
struct RLGButtonStyle:ViewModifier {
let isRightAlignment: Bool
func body (content:Content) -> some View {
        content
        .frame(maxWidth: .infinity,alignment: isRightAlignment ? .trailing : .center)
        .padding(.vertical, CGFloat(StyleDictionarySize.spacing300))
        .font(
            Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeButtonText))
                .weight(.bold)
        )
        .lineLimit(nil)
        .multilineTextAlignment(isRightAlignment ? .trailing : .center)
        .minimumScaleFactor(0.5)
        .cornerRadius(CGFloat(StyleDictionarySize.spacing200))
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing400))
        .baselineOffset(2)
    }
}

//MARK: AccordianRow ViewModifier
struct AccordianRowTitle:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .frame(maxWidth: .infinity,alignment: .topLeading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineMedium),relativeTo: .title3).bold())
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.darkNeutral100))
        .multilineTextAlignment(.leading)
    }
}
struct AccordianRowLabel:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .lineLimit(nil)
        .padding(CGFloat(StyleDictionarySize.spacing100))
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead),relativeTo: .callout))
        .background(Color(StyleDictionaryColor.lightNeutral30))
        .foregroundStyle(Color(StyleDictionaryColor.lightNeutral100))
        .cornerRadius(CGFloat(StyleDictionarySize.spacing100))
    }
}
struct AccordianRowSubTitle:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .frame(maxWidth: .infinity,alignment: .topLeading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeFootnote),relativeTo: .footnote))
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral80): Color(StyleDictionaryColor.lightNeutral0))
        .multilineTextAlignment(.leading)
    }
}
struct AccordianRowContent:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .frame(maxWidth: .infinity,alignment: .topLeading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge),relativeTo: .body))
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100): Color(StyleDictionaryColor.lightNeutral0))
        .multilineTextAlignment(.leading)
        .padding(.top, CGFloat(StyleDictionarySize.spacing400))
        .padding(.leading, CGFloat(StyleDictionarySize.spacing300))
    }
}
struct AccordianListRowContent:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(.accordianRowContent)
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100): Color(StyleDictionaryColor.lightNeutral0))
    }
}
struct AccordianRowPadding:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .padding()
        .cornerRadius(CGFloat(StyleDictionarySize.spacing200))
        .accentColor(Color(StyleDictionaryColor.secondary100))
        Divider()
            .background(Color(StyleDictionaryColor.secondary100))
            .padding(.horizontal,CGFloat(StyleDictionarySize.spacing300))
    }
}

//MARK: Accordian list
struct AccordianListTitle:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeDisplaySmall),relativeTo: .title2))
        .foregroundStyle(colorScheme == .light ? Color(StyleDictionaryColor.primary100) : Color(StyleDictionaryColor.lightNeutral0))
    }
}
struct AccordianListSubTitle:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyBody, size: CGFloat(StyleDictionarySize.typographySizeBodyLarge),relativeTo: .body))
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.lightNeutral0))
    }
}
struct AccordianListOpenCloseButton:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeButtonText),relativeTo: .callout).bold())
        .foregroundStyle(colorScheme == .light ? Color(StyleDictionaryColor.primary80) : Color(StyleDictionaryColor.lightNeutral0))
    }
}
struct AccordianListSeparator:ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .frame(height: 2)
        .background(colorScheme == .light ? Color(StyleDictionaryColor.primary100) :Color(StyleDictionaryColor.lightNeutral0))
        .padding([.horizontal], CGFloat(StyleDictionarySize.spacing600))
    }
}

//MARK: TextFieldPrefixSuffix ViewModifier
struct TextFieldPrefixSuffix: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let isDisabled: Bool
    let dynamicHeight: CGFloat
    func body (content: Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCallout), relativeTo: .callout))
        .foregroundColor(isDisabled ? Color(StyleDictionaryColor.primary40) : Color(StyleDictionaryColor.primary100))
        .padding(.vertical, CGFloat(StyleDictionarySize.spacingSpacing250))
        .frame(minWidth: CGFloat(StyleDictionarySize.spacing600))
        .frame(height: dynamicHeight)
        .background(Color(StyleDictionaryColor.primary30))
    }
}

//MARK: RLG List ViewModifier
struct ListSeparator: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content: Content) -> some View {
        content
        .frame(height: 1)
        .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral30) :Color(StyleDictionaryColor.darkNeutral30))
        .padding(.vertical, CGFloat(StyleDictionarySize.spacing100))
        .accessibilityHidden(true)
    }
}

struct ListTitle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeTitleLarge)))
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.primary100) :Color(StyleDictionaryColor.darkNeutral100))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .baselineOffset(2)
    }
}

struct ListRowTitle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body (content:Content) -> some View {
        content
            .font(
                Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineSmall)).weight(.bold)
            )
            .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .baselineOffset(2)
    }
}

struct ListSupportingLabel: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeFootnote)))
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral80) : Color(StyleDictionaryColor.darkNeutral90))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .baselineOffset(2)
    }
}

struct ListLabelTag: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCaption1)))
        .multilineTextAlignment(.center)
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
        .padding(.horizontal, CGFloat(StyleDictionarySize.spacing200))
        .padding(.vertical, 2)
        .background(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral30) : Color(StyleDictionaryColor.darkNeutral70))
        .cornerRadius(CGFloat(StyleDictionarySize.spacing100))
        .baselineOffset(2)
    }
}

struct ListTwoColumnLabel: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeHeadlineSmall)))
        .foregroundColor(colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral100) : Color(StyleDictionaryColor.darkNeutral100))
        .baselineOffset(2)
    }
}

struct ListRowContentModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

func body (content:Content) -> some View {
        content
        .listRowInsets(.init())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

// MARK: RLGTiles View Modifiers and Image Extension
struct RLGTilesTextModifier: ViewModifier {
    let color: Color
    let font: Font
    
    func body (content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .baselineOffset(2)
    }
}

extension Image {
    @ViewBuilder
    func tileIconImageStyle(size: CGFloat, color: Color? = nil) -> some View {
        if let color = color {
            self
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(color)
        } else {
            self
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

// MARK: RLGHeader Top Bar Modifiers
struct RLGTopBarTextModifier: ViewModifier {
    let fontSize: CGFloat
    let color: Color
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let txtAlignment: Alignment
    func body(content: Content) -> some View {
        content
        .font(Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: fontSize))
        .foregroundColor(color)
        .frame(maxWidth: .infinity, alignment: txtAlignment)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .baselineOffset(2)
    }
}

struct CustomCornerAndBottomStroke: ViewModifier {
    var radius: CGFloat
    var style: NavigationalTilesCornerStyle
    var strokeColor: Color = Color(StyleDictionaryColor.lightNeutral30)
    var strokeHeight: CGFloat = 0

    func body(content: Content) -> some View {
        var modified = AnyView(content)
        // Apply corner radius
        switch style {
        case .allCorners:
            modified = AnyView(modified.cornerRadius(radius))
        case .topCorners:
            modified = AnyView(modified.clipShape(RoundedCorner(radius: radius, corners: [.topLeft, .topRight])))
        case .bottomCorners:
            modified = AnyView(modified.clipShape(RoundedCorner(radius: radius, corners: [.bottomLeft, .bottomRight])))
        case .noCorners:
            break
        }

        // Apply bottom border
        return modified.overlay(
            Rectangle()
                .fill(strokeColor)
                .frame(height: strokeHeight)
                .frame(maxHeight: .infinity, alignment: .bottom),
            alignment: .bottom
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
