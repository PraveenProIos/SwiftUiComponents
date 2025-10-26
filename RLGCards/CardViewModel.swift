//
//  CardViewModel.swift
//  DesignSystem-Native-iOS
//
//  Created by Aparna Duddekunta on 24/06/25.
//

import SwiftUI


//MARK: Expressive CardModel
class CardViewModel: ObservableObject {
    @Published var bgColor:Color = .primary100
     func setupTheColorScheme(bgColor: Color) -> Color {
        self.bgColor = bgColor
        return bgColor
    }
    var titleColor: Color {
        switch bgColor {
        case Color(StyleDictionaryColor.primary100):
            return .white
        case Color(StyleDictionaryColor.primary80):
            return .white
        case Color(StyleDictionaryColor.primary20):
            return Color(StyleDictionaryColor.colourButtonTextGhost)
        case Color(StyleDictionaryColor.lightNeutral30):
            return Color(StyleDictionaryColor.colourButtonTextGhost)
        case Color(StyleDictionaryColor.lightNeutral20):
            return Color(StyleDictionaryColor.colourButtonTextGhost)
        default:
            return Color(StyleDictionaryColor.colourButtonTextGhost)
        }
    }

    var subTitleColor: Color {
        switch bgColor {
        case Color(StyleDictionaryColor.primary100):
            return .white
        case Color(StyleDictionaryColor.primary80):
            return .white
        case Color(StyleDictionaryColor.primary20):
            return .gray
        case Color(StyleDictionaryColor.lightNeutral30):
            return .gray
        case Color(StyleDictionaryColor.lightNeutral20):
            return .gray
        default:
            return .gray
        }
        
    }
    var labelTagColor: Color {
        switch bgColor {
        case Color(StyleDictionaryColor.primary100):
            return .black
        case Color(StyleDictionaryColor.primary80):
            return .black
        case Color(StyleDictionaryColor.primary20):
            return .white
        case Color(StyleDictionaryColor.lightNeutral30):
            return .white
        case Color(StyleDictionaryColor.lightNeutral20):
            return .black
        default:
            return .black
        }
        }
    
    var descriptionColor: Color {
        switch bgColor {
        case Color(StyleDictionaryColor.primary100):
            return .white
        case Color(StyleDictionaryColor.primary80):
            return .white
        case Color(StyleDictionaryColor.primary20):
            return .black
        case Color(StyleDictionaryColor.lightNeutral30):
            return .black
        case Color(StyleDictionaryColor.lightNeutral20):
            return .black
        default:
            return .black
        }
        
    }
    var linkColor: Color {
        switch bgColor {
        case Color(StyleDictionaryColor.primary100):
            return Color(StyleDictionaryColor.secondary60)
        case Color(StyleDictionaryColor.primary80):
            return Color(StyleDictionaryColor.secondary60)
        case Color(StyleDictionaryColor.primary20):
            return Color(StyleDictionaryColor.secondary100)
        case Color(StyleDictionaryColor.lightNeutral30):
            return Color(StyleDictionaryColor.secondary100)
        case Color(StyleDictionaryColor.lightNeutral20):
            return Color(StyleDictionaryColor.secondary100)
        default:
            return Color(StyleDictionaryColor.secondary100)
        }
        
    }
}

