//
//  RLGSegmentedControl.swift
//  RLGUIComponent
//
//  Created by Aparna Duddekunta on 10/06/25.
//

import SwiftUI
import Combine
import Combine

public class SegmentSelectionModel: ObservableObject {
    @Published public var selectedIndex: Int = 0

    public init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
    }
}

public struct SegmentedConfig {
    // Colors
    public var containerBackground: Color = Color(UIColor.systemGray5)
    public var borderColor: Color = Color(UIColor.separator)
    public var borderWidth: CGFloat = 1

    public var selectedBackground: Color = .white           // “selected tint / pill”
    public var unselectedBackground: Color = .clear

    public var selectedTextColor: Color = .blue
    public var unselectedTextColor: Color = .primary

    public var separatorColor: Color = Color(UIColor.separator)
    public var separatorWidth: CGFloat = 1
    public var separatorVerticalInset: CGFloat = 6          // inset top/bottom so it doesn’t touch edges
    public var showsSeparators: Bool = true

    // Layout
    public var cornerRadius: CGFloat = 10
    public var indicatorInset: CGFloat = 3                  // inner inset for the selected “pill”
    public var contentHPadding: CGFloat = 10                // per-segment horizontal padding
    public var contentVPadding: CGFloat = 8                 // per-segment vertical padding
    public var containerPadding: CGFloat = 4                // outer padding inside the rounded box

    // Typography
    public var font: Font = .system(size: 14, weight: .semibold)

    public init() { }
}

public struct RLGSegmentedControl: View {
    @ObservedObject var model: SegmentSelectionModel
    private let items: [String]
    private var config: SegmentedConfig
    @Namespace private var ns
    
    public init(model: SegmentSelectionModel, items: [String],
                config: SegmentedConfig = .init()) {
        self.model = model
        self.items = items
        self.config = config
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                let isSelected = (index == model.selectedIndex)
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.95)) {
                        model.selectedIndex = index
                    }
                } label: {
                    Text(items[index])
                        .font(config.font)
                        .foregroundColor(isSelected ? config.selectedTextColor : config.unselectedTextColor)
                        .padding(.horizontal, config.contentHPadding)
                        .padding(.vertical, config.contentVPadding)
                        .frame(maxWidth: .infinity)
                        .lineLimit(nil)
                        .baselineOffset(2)
                        .background(
                            Group {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: max(CGFloat(StyleDictionarySize.spacing100), config.cornerRadius - config.contentVPadding))
                                        .fill(config.selectedBackground)
                                        .matchedGeometryEffect(id: "indicator", in: ns)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .background(isSelected ? Color.clear : config.unselectedBackground)
                // Accessibility
                .accessibilityIdentifier(segmentIdentifier(index))
                .accessibilityLabel(Text(items[index]))
                .accessibilityValue(Text(isSelected ? StringConstants.selectedString : StringConstants.notSelected))
//                .accessibilityAddTraits(isSelected ? .isSelected : [])
                .accessibilityHint(Text( isSelected ? "" : "\(StringConstants.doubleTapToSelect) \(items[index])"))
                // Separator
                if config.showsSeparators &&
                   index < items.count - 1 &&
                   index != model.selectedIndex &&
                   index + 1 != model.selectedIndex {
                    Rectangle()
                        .fill(config.separatorColor)
                        .frame(width: config.separatorWidth, height: totalHeight)
                }
            }
        }
        .padding(config.containerPadding)
        .background(config.containerBackground)
        .overlay(
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .stroke(config.borderColor, lineWidth: config.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
        .contentShape(RoundedRectangle(cornerRadius: config.cornerRadius))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(StringConstants.rlgSegmentedControl)
    }
    // Add a helper to build stable IDs
    private func segmentIdentifier(_ index: Int) -> String {
        "RLGSegmentedControl.segment.\(index)"
    }
    
    var totalHeight: CGFloat {
        let fontName = StyleDictionaryTypography.typographyFamilyTitle
        let fontSize = CGFloat(StyleDictionarySize.typographySizeSubhead)
        guard let uiFont = UIFont(name: fontName, size: fontSize) else {
            return config.contentVPadding * 2 // Fallback if font fails
        }
        return config.contentVPadding * 2 + uiFont.lineHeight
    }
}

struct RLGSegment: View {
    @State private var selected = 0
    @Environment(\.colorScheme) var colorScheme
    private var segmentViewModel = SegmentSelectionModel()

    var body: some View {
        let cfg = {
            var c = SegmentedConfig()
            c.containerBackground =  colorScheme == .dark ? Color(StyleDictionaryColor.colourSegmentedControlFillDark) : Color(StyleDictionaryColor.colourSegmentedControlFill)
            c.borderColor = .clear // Not used
            c.borderWidth = 0 // Not Used
            c.selectedBackground = colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.lightNeutral20)
            c.unselectedBackground = colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral30) : Color(StyleDictionaryColor.colourSegmentedControlFill)

            c.selectedTextColor = colorScheme == .dark ? Color(StyleDictionaryColor.colourSegmentedControlTextSelectedDark) : Color(StyleDictionaryColor.colourSegmentedControlTextSelected)
            
            c.unselectedTextColor = colorScheme == .dark ? Color(StyleDictionaryColor.colourSegmentedControlTextDark)  : Color(StyleDictionaryColor.colourSegmentedControlText)
            c.separatorColor = colorScheme == .dark ? Color(StyleDictionaryColor.colourSegmentedControlStrokeSeparatorDark) : Color(StyleDictionaryColor.colourSegmentedControlStrokeSeparator)
            c.separatorWidth = 0.64
            c.separatorVerticalInset = CGFloat(StyleDictionarySize.spacing200)
            c.showsSeparators = true

            c.cornerRadius = CGFloat(StyleDictionarySize.spacing100)
            c.indicatorInset = CGFloat(StyleDictionarySize.spacing100)
            c.contentHPadding = CGFloat(StyleDictionarySize.spacingSpacing250)
            c.contentVPadding = CGFloat(StyleDictionarySize.spacingSpacing250)
            c.containerPadding = CGFloat(StyleDictionarySize.spacing100)
            c.font = Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead))
            return c
        }()

        return VStack(spacing: 16) {
            RLGSegmentedControl(model: segmentViewModel, items: ["Value", "Value"], config: cfg)
           // Text("Selected index: \(selected)")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .ignoresSafeArea()
    }
}

#Preview {
    RLGSegment()
}
