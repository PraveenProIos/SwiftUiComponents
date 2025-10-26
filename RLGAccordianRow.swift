//
//  AccordianRow.swift
//  AccordianButton
//
//  Created by Aparna Duddekunta on 21/05/25.
//

import SwiftUI


// MARK: RLGAccordianRow

  class DisclosureGroupViewModel: ObservableObject {
    @Published  var isExpanded: Bool
      init(isExpanded: Bool) {
          self.isExpanded = isExpanded
      }
}

public struct RLGAccordianRow: View {
    // MARK: Public properities
    public var title: String
    public var subTitle: String?
    public var content: String
    public var titleIcon:String?
    public var labelTag: String?
    public var labelImage: String?
    public var isFocused: Bool
   // @State public var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel =  DisclosureGroupViewModel(isExpanded: false)
    @ScaledMetric(relativeTo: .title3) private var titleIconImageHeight = 16
    @ScaledMetric(relativeTo: .callout) private var labelTagImageHeight = 13

#if DEBUG
    init(title: String, subTitle: String, content: String, titleIcon: String?, labelTag: String?, labelImage: String?, isFocused: Bool, testIsExpanded: Bool) {
        self.title = title
        self.subTitle = subTitle
        self.content = content
        self.titleIcon = titleIcon
        self.labelTag = labelTag
        self.labelImage = labelImage
        self.isFocused = isFocused
        _viewModel = StateObject(wrappedValue: DisclosureGroupViewModel(isExpanded: testIsExpanded))
    }
#endif
    public init(title: String, subTitle: String? = nil, content: String,titleIcon:String? = nil,labelTag: String? = nil,labelImage:String? = nil,isFocused: Bool) {
        self.title = title
        self.subTitle = subTitle
        self.content = content
        self.titleIcon = titleIcon
        self.labelTag = labelTag
        self.labelImage = labelImage
        self.isFocused = isFocused
    }
    public var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(isExpanded: $viewModel.isExpanded,content: {
            
                        Text(content)
                            .modifier(AccordianRowContent())
                            .accessibilityIdentifier("Disclosure Content")
                    }) {
                        titleSection(title: title, subTitle: subTitle, content: content, titleIcon: titleIcon, labelTag: labelTag, labelImage: labelImage)
                            .accessibilityIdentifier("Disclosure Group")
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityHint(viewModel.isExpanded ? "Double tap to collapse.":"Double tap to expand.")
                    .accessibilityValue(viewModel.isExpanded ? "Expanded":"Collapsed")
                    .accessibilityLabel(getAccessibilityLabel())
                    .modifier(AccordianRowPadding())
                }

                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.red, lineWidth: isFocused ? 2 : 0)
                            .padding(.bottom,-6)
                            .padding([.horizontal],6))

    }
    // MARK: Private methods

    private func getAccessibilityLabel() -> String {
        if viewModel.isExpanded {
            return title + "," + (labelTag ?? "") + "," + (subTitle ?? "") + "," + content

        } else {
            return title + "," + (labelTag ?? "") + "," + (subTitle ?? "")

        }
    }
    private func titleSection(title: String, subTitle: String?, content: String,titleIcon: String? ,labelTag: String?,labelImage:String?) -> some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                if let titleIcon =  titleIcon {
                    Image(titleIcon,bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: titleIconImageHeight)
                }
                Text(title)
            }.modifier(AccordianRowTitle())
            
            if let labelTag = labelTag {
                HStack(alignment: .center, spacing: CGFloat(StyleDictionarySize.spacing100)) {
                    Text(labelTag)
                        .fixedSize(horizontal: false, vertical: true)
                    Image(labelImage ?? "",bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: labelTagImageHeight)
                }.modifier(AccordianRowLabel())
                    .padding(.horizontal,titleIcon == nil ? CGFloat(Constants.accrodianRowLabelLeadingZero) : CGFloat(Constants.accrodianRowLabelLeadingSpace))
            }
            
            if let subTitle = subTitle {
                Text(subTitle)
                    .modifier(AccordianRowSubTitle())
                    .padding(.horizontal,titleIcon == nil ? CGFloat(Constants.accrodianRowLabelLeadingZero) : CGFloat(Constants.accrodianRowLabelLeadingSpace))
            }
        }.padding(.horizontal)
    }
}

#Preview {
    VStack {
        RLGAccordianRow(title: "Accordion row 6", subTitle: "Accordion row subTitle 2", content: "This is the content area for the accordion row.", titleIcon: ImageConstatnts.rowTitleIcon, labelTag: "Insurance", labelImage: ImageConstatnts.labelIcon, isFocused: false)

        RLGAccordianRow(title: "Accordion row 6", subTitle: "Accordion row subTitle 2", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page.This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page.", titleIcon: ImageConstatnts.rowTitleIcon, labelTag: "Insurance", labelImage: ImageConstatnts.labelIcon, isFocused: true)
   }
}
