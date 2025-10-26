//
//  RLGDetailView.swift
//  ExpandableCard
//
//  Created by Praveen Reddy on 15/10/25.
//

import SwiftUI

public struct DetailConfig {
    // Colors
    public var backgroundColor: Color = Color(.systemBackground)
    public var titleColor: Color = .primary
    public var descriptionColor: Color = .secondary
    public var lineColor: Color = .blue
    // Typography
    public var titleFont: Font = .system(size: 14, weight: .semibold)
    public var descriptionFont: Font = .system(size: 14, weight: .semibold)
    // Initializer
    public init() { }
}

private enum DetailMetrics {
    // Header metrics
    static let titleImageArrowHstackHorizontalSpacing: CGFloat = CGFloat(StyleDictionarySize.spacing500)
    static let headerLeadingtoEyeImg: CGFloat = CGFloat(StyleDictionarySize.spacing200)
    static let textToArrowSpacing: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    static let descriptionBottomSpacing: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    static let descriptionTrailingSpacing: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    static let headerVerticalPadding: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    static let cornerRadius: CGFloat = CGFloat(StyleDictionarySize.spacing100)
    static let leftLineWidth: CGFloat = CGFloat(StyleDictionarySize.spacing200)
}


public struct RLGDetailView: View {
    private let title: String
    private let description: String
    private let leftImageName: String
    private let leftimageIsHidden:Bool
    private let rightImageName: String
    private var config: DetailConfig
    
    @State private var isExpanded = false
    @ScaledMetric(relativeTo: .body) private var iconHeight = 18
    @ScaledMetric(relativeTo: .body) private var arrowIconHeight = 16
    
    public init(title: String,description: String,leftImageName: String,leftimageIsHidden:Bool,rightImageName:String,
                config: DetailConfig = .init()) {
        self.title = title
        self.description = description
        self.leftImageName = leftImageName
        self.leftimageIsHidden = leftimageIsHidden
        self.rightImageName = rightImageName
        self.config = config
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Section
            HStack(spacing: DetailMetrics.headerLeadingtoEyeImg) {
                if self.leftimageIsHidden {
                    Image(leftImageName, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: iconHeight)
                }
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(title)
                            .font(config.titleFont)
                            .foregroundColor(config.titleColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .baselineOffset(2)
                            .padding(.trailing, DetailMetrics.headerLeadingtoEyeImg)
                            .accessibilityIdentifier(StringConstants.headerTitle)
                        
                        Image(rightImageName, bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(height: arrowIconHeight)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isExpanded)
                            .accessibilityIdentifier(StringConstants.arrowImage)
                    }
                    .padding(.vertical, DetailMetrics.headerVerticalPadding)
                }
            }
            .padding(.leading, DetailMetrics.titleImageArrowHstackHorizontalSpacing)
            .padding(.trailing, DetailMetrics.textToArrowSpacing)
            .contentShape(Rectangle())
            .accessibilityIdentifier(StringConstants.expandableContainer)
            
            // Description
            if isExpanded {
                Text(description)
                    .font(config.descriptionFont)
                    .foregroundColor(config.descriptionColor)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, dynamicDescriptionLeading)
                    .padding(.trailing, DetailMetrics.descriptionTrailingSpacing)
                    .padding(.bottom, DetailMetrics.descriptionBottomSpacing)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .accessibilityLabel(Text(description))
                    .accessibilityIdentifier(StringConstants.descriptionText)
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                isExpanded.toggle()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DetailMetrics.cornerRadius, style: .continuous)
                .fill(config.backgroundColor)
        )
        .overlay(alignment: .leading) {
            if #available(iOS 17.0, *) {
                UnevenRoundedRectangle(
                    topLeadingRadius: CGFloat(DetailMetrics.leftLineWidth / 2),
                    bottomLeadingRadius: CGFloat(DetailMetrics.leftLineWidth / 2),
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
                .fill(config.lineColor)
                .frame(width: DetailMetrics.leftLineWidth)
                .accessibilityHidden(true)
            } else {
                Rectangle()
                    .fill(config.lineColor)
                    .frame(width: DetailMetrics.leftLineWidth)
                    .clipShape(RoundedCorner(radius: CGFloat(DetailMetrics.leftLineWidth / 2), corners: [.topLeft, .bottomLeft]))
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("\(title), \(isExpanded ? StringConstants.collapse : StringConstants.expand )"))
        .accessibilityHint(Text("Double tap to \(isExpanded ? StringConstants.collapse : StringConstants.expand) the description"))
    }
    
    var dynamicDescriptionLeading: CGFloat {
        if leftimageIsHidden {
            return DetailMetrics.titleImageArrowHstackHorizontalSpacing + iconHeight + DetailMetrics.headerLeadingtoEyeImg
        }else{
            return DetailMetrics.titleImageArrowHstackHorizontalSpacing
        }
    }
}

// Helper for iOS 13–16
struct RoundedCorner2: Shape {
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

struct RLGDView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        let cfg = {
            var c = DetailConfig()
            c.backgroundColor = colorScheme == .dark ? Color(StyleDictionaryColor.colourDetailFillDark) : Color(StyleDictionaryColor.colourDetailFill)
            c.titleColor = colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.colourDetailText)
            c.descriptionColor = colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.colourDetailText)
            c.lineColor = colorScheme == .dark ? Color(StyleDictionaryColor.colourDetailStroke) : Color(StyleDictionaryColor.colourDetailStroke)
            c.titleFont = Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCallout))
            c.descriptionFont = Font.custom(StyleDictionaryTypography.typographyFamilyBody, size:CGFloat( StyleDictionarySize.typographySizeBodyMedium))
            return c
        }()
        
        ScrollView {
            VStack(spacing: CGFloat(StyleDictionarySize.spacing300)) {
                RLGDetailView(title: "Main text goes here", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", leftImageName: colorScheme == .dark ? ImageConstatnts.eyeDarkImg : ImageConstatnts.eyeImg, leftimageIsHidden: true, rightImageName: colorScheme == .dark ? ImageConstatnts.downArrowDarkImg : ImageConstatnts.downArrowImg, config: cfg)
            }
            .padding(.top, CGFloat(StyleDictionarySize.spacing400))
            .padding(.horizontal, CGFloat(StyleDictionarySize.spacing400))
        }
        .background(Color.gray.opacity(0.1))
    }
}


#Preview {
    RLGDView()
}
