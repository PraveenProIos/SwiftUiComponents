//
//  RLGDividerLine.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini yadav on 16/09/25.
//

import SwiftUI


public enum DividerStyleType {
    case defautlStyle
    case purple
}

public struct RLGDividerLine: View {
    @Environment(\.colorScheme) var colorScheme
    public var styleType: DividerStyleType
    public var backgroundColor: Color?
    public var verticalPadding: CGFloat
    public var horizontalPadding: CGFloat
    public var height: CGFloat

    public init(styleType: DividerStyleType = .defautlStyle, backgroundColor: Color? = nil, verticalPadding: CGFloat = 10, horizontalPadding: CGFloat = CGFloat(StyleDictionarySize.spacing400), height: CGFloat = 1) {
        self.styleType = styleType
        self.backgroundColor = backgroundColor
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.height = height
    }
    
    public var body: some View {
        VStack {
            Divider()
                .frame(height: height)
                .background(getDividerColor())
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .accessibilityHidden(true)
        }
        .background(getBackgroundColor())
    }
    
    private func getDividerColor() -> Color {
        if styleType == .purple {
            Color(StyleDictionaryColor.primary60)
        } else {
            colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral30) : Color(StyleDictionaryColor.darkNeutral70)
        }
    }
    
    private func getBackgroundColor() -> Color {
        if let color = backgroundColor {
            color
        } else {
            if styleType == .purple {
                Color(StyleDictionaryColor.primary100)
            } else {
                colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.lightNeutral90)
            }
        }
    }
}

#Preview {
    VStack(spacing: CGFloat(StyleDictionarySize.spacing400)) {
        RLGDividerLine(styleType: .purple)
        RLGDividerLine(styleType: .defautlStyle)
    }
}
