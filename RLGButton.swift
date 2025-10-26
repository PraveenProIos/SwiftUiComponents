//
//  RLGButton.swift
//  RLGUIComponents
//
//  Created by Aparna Duddekunta on 08/05/25.
//
import SwiftUI


// MARK: ICONConfig
public struct IConConfig {
    public let icon: String
    public let isSystemIcon: Bool
    public let iconPosition: IconPosition
    public enum IconPosition {
        case left, right, both
    }
    public init(icon: String,
                isSystemIcon: Bool,
                iconPosition: IconPosition) {
        self.icon = icon
        self.isSystemIcon = isSystemIcon
        self.iconPosition = iconPosition
    }
}

// MARK: RLGButton
public struct RLGButton: View {
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .body) var iconHeight = 16
    
    // MARK: Public properities
    public var styleType: ButtonStyleType
    public var title: String
    public var isRightAlignment: Bool
    @Binding public var isFocused: Bool
    public var isDisabled: Bool = false
    public var isInvertedButton: Bool = false
    public var horizontalPadding: CGFloat
    public var iconConfig: IConConfig?
    public let action: () -> Void
    
    public init(styleType: ButtonStyleType,
                title: String,
                isRightAlignment: Bool = false,
                isFocused: Binding<Bool>,
                isDisabled: Bool,
                isInvertedButton: Bool = false,
                horizontalPadding: CGFloat = CGFloat(StyleDictionarySize.spacing300),
                iconConfig: IConConfig? = nil,
                action: @escaping () -> Void) {
        self.styleType = styleType
        self.title = title
        self.isRightAlignment = isRightAlignment
        self._isFocused = isFocused
        self.isDisabled = isDisabled
        self.isInvertedButton = isInvertedButton
        self.horizontalPadding = horizontalPadding
        self.iconConfig = iconConfig
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            content
                .modifier(RLGButtonStyle(isRightAlignment: isRightAlignment))
                .foregroundColor(getForegroundColor())
                .background(getBackgroundColor())
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(getCornerRadiusColor(), lineWidth: 2))
                .padding(isFocused ? 3 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: CGFloat(StyleDictionarySize.spacing100))
                        .stroke(Color.red, lineWidth: isFocused ? 2 : 0))
                .accessibilityIdentifier(title)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint(isDisabled ? "" : StringConstants.accessbilityLbl_DoubleTapTo)
        }
        .padding([.horizontal], horizontalPadding)
        .buttonStyle(PlainButtonStyle())
        .allowsHitTesting(!isDisabled) //disabled Button
    }
    //MARK: - Private methods
    
    @ViewBuilder
    private var content: some View {
        HStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
            if iconConfig != nil {
                if iconConfig?.iconPosition == .left {
                    ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true, iconHeight: iconHeight)
                    Text(title)
                } else  if iconConfig?.iconPosition == .right {
                    Text(title)
                    ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true, iconHeight: iconHeight)
                } else {
                    ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true, iconHeight: iconHeight)
                    Text(title)
                    ImageViewIcon(icon: iconConfig?.icon ?? "", isSystemIcon: iconConfig?.isSystemIcon ?? true, iconHeight: iconHeight)
                }
            } else {
                Text(title)
            }
        }
    }

    private func getBackgroundColor() -> Color {
        if isInvertedButton {
            switch styleType {
            case .primary:
                return isDisabled ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.secondary80)
            case .secondary:
                return isDisabled ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.primary60)
            case .destructive:
                return isDisabled ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.semanticDanger60)
            case .ghost, .text:
                return Color.clear
            }
        } else {
            if colorScheme == .light {
                switch styleType {
                case .primary:
                    return isDisabled ? Color(StyleDictionaryColor.lightNeutral50) : Color(StyleDictionaryColor.secondary100)
                case .secondary:
                    return isDisabled ? Color(StyleDictionaryColor.lightNeutral50) : Color(StyleDictionaryColor.primary80)
                case .destructive:
                    return isDisabled ? Color(StyleDictionaryColor.lightNeutral50) : Color(StyleDictionaryColor.semanticDanger60)
                case .ghost, .text:
                    return Color.clear
                }
            } else {
                switch styleType {
                case .primary:
                    return isDisabled ? Color(StyleDictionaryColor.darkNeutral80) : Color(StyleDictionaryColor.secondary80)
                case .secondary:
                    return isDisabled ? Color(StyleDictionaryColor.darkNeutral80) : Color(StyleDictionaryColor.primary60)
                case .destructive:
                    return isDisabled ? Color(StyleDictionaryColor.darkNeutral80) : Color(StyleDictionaryColor.semanticDanger60)
                case .ghost, .text:
                    return Color.clear
                }
            }
        }
    }
    
    private func getForegroundColor() -> Color {
        switch styleType {
        case .primary, .secondary, .destructive:
            if isInvertedButton {
                return isDisabled ? Color(StyleDictionaryColor.lightNeutral20) : Color(StyleDictionaryColor.lightNeutral0)
            } else {
                if colorScheme == .light {
                    return isDisabled ? Color(StyleDictionaryColor.lightNeutral10) : Color(StyleDictionaryColor.lightNeutral0)
                } else {
                    return isDisabled ? Color(StyleDictionaryColor.darkNeutral90) : Color(StyleDictionaryColor.darkNeutral100)
                }
            }
        case .ghost, .text:
            if isInvertedButton {
                return isDisabled ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.lightNeutral0)
            } else {
                if colorScheme == .light {
                    return isDisabled ? Color(StyleDictionaryColor.lightNeutral50) : Color(StyleDictionaryColor.primary80)
                } else {
                    return isDisabled ? Color(StyleDictionaryColor.darkNeutral80) : Color(StyleDictionaryColor.darkNeutral100)
                }
            }
        }
    }
    
    private func getCornerRadiusColor() -> Color {
        if styleType == .ghost {
            if isInvertedButton {
                return isDisabled ? Color(StyleDictionaryColor.lightNeutral60) : Color(StyleDictionaryColor.lightNeutral0)
            } else {
                if colorScheme == .light {
                    return isDisabled ? Color(StyleDictionaryColor.lightNeutral50) : Color(StyleDictionaryColor.primary80)
                } else {
                    return isDisabled ? Color(StyleDictionaryColor.darkNeutral80) : Color(StyleDictionaryColor.darkNeutral100)
                }
            }
        } else {
            return .clear
        }
    }
}

//MARK: Preview
#Preview {
    VStack {
        RLGButton(styleType: .primary, title: "Action",isRightAlignment: true, isFocused: .constant(false), isDisabled: false, isInvertedButton: true, iconConfig: IConConfig(icon: ImageConstatnts.vectorArrowIcon, isSystemIcon: false, iconPosition: .right), action: {})
        
        RLGButton(styleType: .primary, title: "Primary", isFocused: .constant(false), isDisabled: false,isInvertedButton: true, iconConfig: IConConfig(icon: ImageConstatnts.labelIcon, isSystemIcon: false, iconPosition: .both), action: {})
        RLGButton(styleType: .ghost, title: "Primary2", isFocused: .constant(false), isDisabled: false, isInvertedButton: false, iconConfig: IConConfig(icon: ImageConstatnts.labelIcon, isSystemIcon: false, iconPosition: .right), action: {})
        
        RLGButton(styleType: .primary, title: "Primary Disabled", isFocused: .constant(false), isDisabled: true, isInvertedButton: false, iconConfig: nil, action: {})
        RLGButton(styleType: .ghost, title: "Ghost Disabled", isFocused: .constant(false), isDisabled: true, isInvertedButton: false, iconConfig: nil, action: {})
        RLGButton(styleType: .text, title: "Text Disabled", isFocused: .constant(false), isDisabled: true, isInvertedButton: false, iconConfig: nil, action: {})
    }
}


