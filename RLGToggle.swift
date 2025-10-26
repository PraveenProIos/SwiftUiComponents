//
//  SwiftUIView.swift
//  DesignSystem-Native-iOS
//
//  Created by Nandini Yadav on 19/08/25.
//

import SwiftUI


public struct RLGToggle: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    // Dynamically scale size based on system text size
    private var toggleSize: CGSize {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            return CGSize(width: 80, height: 44)
        case .accessibilityExtraExtraLarge:
            return CGSize(width: 70, height: 40)
        case .accessibilityExtraLarge:
            return CGSize(width: 65, height: 36)
        default:
            return CGSize(width: 51, height: 31) // Normal size
        }
    }
    
    // Dynamically offset based on system text size
    private var thumbOffset: CGFloat {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            return CGFloat(17)
        case .accessibilityExtraExtraLarge:
            return CGFloat(15)
        case .accessibilityExtraLarge:
            return CGFloat(14.5)
        default:
            return CGFloat(10)// Normal size
        }
    }
    
    @Binding var isOn: Bool
    public var toggleLabelName: String

    public init(isOn: Binding<Bool>, toggleLabelName: String = StringConstants.emptyString) {
        self._isOn = isOn
        self.toggleLabelName = toggleLabelName
    }
    
    public var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Toggle(StringConstants.emptyString, isOn: $isOn)
                .toggleStyle(CustomToggleStyle(onColor: getTheOnColor(), offColor: getTheOffColor(), thumbColor: Color(StyleDictionaryColor.lightNeutral0), cornerRadius: toggleSize.height/2, toggleSize: toggleSize, thumbOffsetX: thumbOffset))
                .accessibilityLabel(toggleLabelName)
                .accessibilityValue(isOn ? StringConstants.on : StringConstants.off)
                .accessibilityHint(isOn ? StringConstants.emptyString : StringConstants.accessbilityLbl_DoubleTapTo)
                .accessibilityIdentifier(toggleLabelName)
                .accessibilityAddTraits(isOn ? .isSelected : [])
        }
    }
    
    private func getTheOnColor() -> Color {
        colorScheme == .light ? Color(StyleDictionaryColor.secondary100) : Color(StyleDictionaryColor.secondary80)
    }
    
    private func getTheOffColor() -> Color {
        colorScheme == .light ? Color(StyleDictionaryColor.lightNeutral40) : Color(StyleDictionaryColor.darkNeutral80)
    }
}

struct CustomToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var thumbColor: Color
    var cornerRadius: CGFloat
    var toggleSize: CGSize
    var thumbOffsetX: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
            .fill(configuration.isOn ? onColor : offColor)
            .frame(width: toggleSize.width, height: toggleSize.height)
            .overlay(
                Circle()
                    .fill(thumbColor)
                    .frame(width: toggleSize.height - 5, height: toggleSize.height - 5)
                    .padding(2)
                    .offset(x: configuration.isOn ? thumbOffsetX : -thumbOffsetX)
            )
            .onTapGesture {
                withAnimation(.smooth(duration: 0.2)) {
                    configuration.isOn.toggle()
                }
            }
    }
}

#Preview {
    RLGToggle(isOn: .constant(false))
}
