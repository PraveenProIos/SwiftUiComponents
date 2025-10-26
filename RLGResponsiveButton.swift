//
//  RLGResponsiveButtonView.swift
//  RLGUIComponents
//
//  Created by Aparna Duddekunta on 09/05/25.
//

import SwiftUI

public struct RLGResponsiveButton: View {
    //MARK: Public properties
    
    public var styleType1: ButtonStyleType
    public var styleType2: ButtonStyleType
    public var title1: String
    public var title2: String
    @Binding public var isFocused1: Bool
    @Binding public var isFocused2: Bool
    public var isDisabled1: Bool = false
    public var isDisabled2: Bool = false
    public var iconConfig1: IConConfig?
    public var iconConfig2: IConConfig?
    public let action1: () -> Void
    public let action2: () -> Void

    public init(styleType1: ButtonStyleType,
                styleType2: ButtonStyleType,
                title1: String, title2: String,
                isFocused1: Binding<Bool>,
                isFocused2: Binding<Bool>,
                isDisabled1: Bool,
                isDisabled2: Bool,
                iconConfig1: IConConfig? = nil,
                iconConfig2: IConConfig? = nil,
                action1: @escaping () -> Void,
                action2: @escaping () -> Void) {
        self.styleType1 = styleType1
        self.styleType2 = styleType2
        self.title1 = title1
        self.title2 = title2
        self._isFocused1 = isFocused1
        self._isFocused2 = isFocused2
        self.isDisabled1 = isDisabled1
        self.isDisabled2 = isDisabled2
        self.iconConfig1 = iconConfig1
        self.iconConfig2 = iconConfig2
        self.action1 = action1
        self.action2 = action2
    }

    public var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < 512 {
                VStack {
                    RLGButton(
                        styleType: styleType1,
                        title: title1,
                        isFocused: $isFocused1,
                        isDisabled: isDisabled1,
                        iconConfig: iconConfig1,
                        action: action1)
                    RLGButton(
                        styleType: styleType2,
                        title: title2,
                        isFocused: $isFocused2,
                        isDisabled: isDisabled2,
                        iconConfig: iconConfig2,
                        action: action2)
                }
            } else {
                HStack {
                    RLGButton(styleType: styleType1, title: title1, isFocused: $isFocused1, isDisabled: isDisabled1, iconConfig: iconConfig1, action: action1)

                    RLGButton(styleType: styleType2, title: title2, isFocused: $isFocused2, isDisabled: isDisabled2, iconConfig: iconConfig2, action: action2)
                }

            }
        }
    }
}

//MARK: Preview

#Preview {
    RLGResponsiveButton(styleType1: .primary,
                         styleType2: .secondary,
                         title1: "Primary Button",
                         title2: "Secondary Button",
                         isFocused1: .constant(false),
                         isFocused2: .constant(false),
                         isDisabled1: false,
                         isDisabled2: false,
                         iconConfig1: IConConfig(icon: ImageConstatnts.downArrow, isSystemIcon: false, iconPosition: .left),
                         iconConfig2: IConConfig(icon: ImageConstatnts.systemImageBell, isSystemIcon: true, iconPosition: .right), action1: {},
                            action2: {})


}

