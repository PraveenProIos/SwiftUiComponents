//
//  SwiftUIView.swift
//  DesignSystem-Native-iOS
//
//  Created by Praveen Reddy on 22/10/25.
//

import SwiftUI
import Combine

public class SpinnerViewModel: ObservableObject {
    @Published public var isLoading: Bool = true
    public init(isLoading: Bool = true) {
        self.isLoading = isLoading
    }
}

public enum IndicatorSize {
    case small
    case medium
    case large

    var scale: CGFloat {
        switch self {
        case .small: return 1.0
        case .medium: return 1.25
        case .large: return 1.5
        }
    }
}

public enum LabelOrientation {
    case horizontal
    case vertical
}

public struct RLGSpinner<Label: View>: View {
    @ObservedObject public var viewModel: SpinnerViewModel
    public var indicatorSize: IndicatorSize = .small
    public var indicatorColor: Color = .blue
    public var labelTextColor: Color = .blue
    
    public var orientation: LabelOrientation = .horizontal
    public var font: Font = .body
    public var label: () -> Label
    
    public init(
        viewModel: SpinnerViewModel,
        indicatorSize: IndicatorSize = .small,
        indicatorColor: Color = .blue,labelTextColor:Color = .blue,
        orientation: LabelOrientation = .horizontal,
        font: Font = .body,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.viewModel = viewModel
        self.indicatorSize = indicatorSize
        self.indicatorColor = indicatorColor
        self.labelTextColor = labelTextColor
        self.orientation = orientation
        self.font = font
        self.label = label
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                layout
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text(StringConstants.loading))
                    .accessibilityHint(Text(StringConstants.spinnerHint))
            }
        }
    }
    
    private var layout: some View {
        Group {
            if orientation == .horizontal {
                HStack{
                    progressView
                    if indicatorSize == .small {
                        label().font(font).foregroundColor(labelTextColor)
                            .padding(.horizontal, CGFloat( StyleDictionarySize.spacing100))
                    }else{
                        label().font(font).foregroundColor(labelTextColor)
                            .padding(.horizontal, indicatorSize == .medium ? CGFloat( StyleDictionarySize.spacing100) : CGFloat( StyleDictionarySize.spacing200))
                    }
                }
            } else {
                VStack {
                    progressView
                    if indicatorSize == .small {
                        label().font(font).foregroundColor(labelTextColor)
                            .padding(.vertical, CGFloat( StyleDictionarySize.spacing100))
                    }else{
                        label().font(font).foregroundColor(labelTextColor)
                            .padding(.vertical, indicatorSize == .medium ? CGFloat(StyleDictionarySize.spacing100) : CGFloat(StyleDictionarySize.spacing200) )
                    }
                }
            }
        }
    }
    
    private var progressView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: indicatorColor))
            .scaleEffect(indicatorSize.scale)
            .accessibilityHidden(true)
    }
}

struct Demo: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var spinnerVM = SpinnerViewModel()
    
    var body: some View {
        VStack(spacing: CGFloat(StyleDictionarySize.typographyLineHeightTitleLarge)) {
            // Vertical Spinners
            RLGSpinner(
                viewModel: spinnerVM,
                indicatorSize: .large,
                indicatorColor:  colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral90) : Color(StyleDictionaryColor.lightNeutral80) ,
                labelTextColor: colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral90) : Color(StyleDictionaryColor.lightNeutral80) ,
                orientation: .vertical,
                font:        Font.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeCallout))
            ) {
                Text("Status...")
            }
        }
    }
}

#Preview {
    Demo()
}
