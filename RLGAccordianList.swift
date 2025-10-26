//
//  RLGAccordian3.swift
//  AccordianButton
//
//  Created by Aparna Duddekunta on 22/05/25.
//
import SwiftUI

public struct CustomAccordionRowData: Identifiable {
    public let id = UUID()
    public var title: String
    public var subTitle: String?
    public var content: String
    public let titleIcon:String?
    public let labelTag: String?
    public let labelImage: String?
    public var isExpanded = false
#if DEBUG
    public init(title: String, subTitle: String? = nil, content: String, titleIcon:String? = nil, labelTag: String? = nil, labelImage: String? = nil,testIsExpanded :Bool) {
        self.title = title
        self.subTitle = subTitle
        self.content = content
        self.titleIcon = titleIcon
        self.labelTag = labelTag
        self.labelImage = labelImage
        self.isExpanded = testIsExpanded
    }
#endif

    public init(title: String, subTitle: String? = nil, content: String, titleIcon:String? = nil, labelTag: String? = nil, labelImage: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.content = content
        self.titleIcon = titleIcon
        self.labelTag = labelTag
        self.labelImage = labelImage
    }
}

public struct RLGAccordianList: View {
    @Binding public var rows: [CustomAccordionRowData]
    public let headerTitle: String
    public let headerSubtitle: String?
    public let icon: String?
    @State private var isAllExpanded = false
    @ScaledMetric(relativeTo: .title3) private var listTitleIconImageHeight = 16
    @ScaledMetric(relativeTo: .callout) private var labelTagImageHeight = 13

#if DEBUG
    public init(rows: [CustomAccordionRowData], headerTitle: String, headerSubtitle: String,icon: String? = nil,isAllExpanded:Bool) {
        self._rows = Binding.constant(rows)
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.icon =  icon
        self._isAllExpanded = State(initialValue: isAllExpanded)
    }
#endif
    public init(rows: Binding<[CustomAccordionRowData]>, headerTitle: String, headerSubtitle: String,icon: String? = nil) {
        self._rows = rows
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.icon =  icon
    }

    public var body: some View {
        VStack {
            titleSection(rows: $rows, headerTitle: headerTitle, headerSubtitle: headerSubtitle, icon: icon,isAllExpanded: $isAllExpanded)
            .padding()
            Divider()
                .modifier(AccordianListSeparator())
            //Mark: Disclosure group list section
                List {
                    ForEach(rows.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            DisclosureGroup(isExpanded: $rows[index].isExpanded,content: {
                                
                                Text(rows[index].content)
                                    .modifier(AccordianListRowContent())

                            }) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        if let rowTitleIcon = rows[index].titleIcon {
                                            Image(rowTitleIcon,bundle: .module)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: listTitleIconImageHeight)
                                        }
                                        Text(rows[index].title)
                                    }.modifier(AccordianRowTitle())
                                    
                                    
                                    if let labelTag = rows[index].labelTag {
                                        HStack {
                                            Text(labelTag)
                                            Image(rows[index].labelImage ?? "",bundle: .module)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: labelTagImageHeight)
                                        }.modifier(AccordianRowLabel())
                                            .padding(.horizontal,rows[index].titleIcon == nil ? CGFloat(Constants.accrodianRowLabelLeadingZero) : CGFloat(Constants.accrodianRowLabelLeadingSpace))
                                    }
                                    Text(rows[index].subTitle ?? "")
                                        .modifier(AccordianRowSubTitle())
                                        .padding(.horizontal,rows[index].titleIcon == nil ? CGFloat(Constants.accrodianRowLabelLeadingZero) : CGFloat(Constants.accrodianRowLabelLeadingSpace))
                                }
                            }
                        }
                        .accessibilityIdentifier(rows[index].isExpanded ? "Accordian Row Expanded" : "Accordian Row Collapsed")
                        .accessibilityElement(children: .ignore)
                        .accessibilityHint(rows[index].isExpanded ? "Double tap to collapse":"Double tap to expand")
                        .accessibilityValue(rows[index].isExpanded ? "Expanded":"Collapsed")
                        .accessibilityLabel(getAccessibilityLabel(row: rows[index]))
                        .accentColor(.chevronIconColor)
                        .listRowSeparator(.hidden)
                        Divider()
                            .frame(height: 1)
                            .background(Color.chevronIconColor)

                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        
                    }

                    .listRowBackground(Color.clear)
                }

            .scrollContentBackground(.hidden)
            .padding(.horizontal, CGFloat(Constants.accrodianListHorizontalSpace))
        }


    }
    
private func getAccessibilityLabel(row: CustomAccordionRowData) -> String {
    
    if row.isExpanded {
        return row.title + "," + (row.labelTag ?? "") + "," + (row.subTitle ?? "") + "," + row.content
    
            } else {
                return row.title + "," + (row.labelTag ?? "") + "," + (row.subTitle ?? "")

            }
}

private func titleSection(rows: Binding<[CustomAccordionRowData]>, headerTitle: String, headerSubtitle: String?,icon: String?,isAllExpanded: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if let listIcon = icon {
                        Image(listIcon, bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(height: listTitleIconImageHeight)
                    }
                    Text(headerTitle)
                }.modifier(AccordianListTitle())
                if let headerSubtitle = headerSubtitle {
                    Text(headerSubtitle)
                        .modifier(AccordianListSubTitle())
                        .padding(.horizontal,icon == nil ? 0 : 30)
                }
              
                HStack {
                    Spacer()
                    Button(action: {
                        isAllExpanded.wrappedValue.toggle()
                        rows.indices.forEach { index in
                            rows[index].wrappedValue.isExpanded = isAllExpanded.wrappedValue
                        }
                    })
                    {
                        Text(isAllExpanded.wrappedValue ? "Close All" : "Open All")
                            .modifier(AccordianListOpenCloseButton())
                            .accessibilityIdentifier("openAllButton")
                            .accessibilityHint("Double tap to activate")

                    }
                }
            }
            .padding(.horizontal,15)
            Spacer()
        }
    }
}


//MARK: Sample app usage
struct CustomContentView: View {
    @State private var rows: [CustomAccordionRowData] = [
        CustomAccordionRowData(title: "Accordian Row 1", subTitle: "Accordian row description", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: ImageConstatnts.rowTitleIcon),
        CustomAccordionRowData(title: "Accordian Row 2", subTitle: "Accordian row description", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: ImageConstatnts.rowTitleIcon,labelTag: "Insurance",labelImage: ImageConstatnts.labelIcon),
        CustomAccordionRowData(title: "Accordian Row 2", subTitle: "Accordian row description", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: ImageConstatnts.rowTitleIcon),
        CustomAccordionRowData(title: "Accordian Row 2", subTitle: "Accordian row description", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: ImageConstatnts.rowTitleIcon),
        CustomAccordionRowData(title: "Accordian Row 2", subTitle: "Accordian row description", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: ImageConstatnts.rowTitleIcon),
        CustomAccordionRowData(title: "Accordian Row 2", subTitle: "Accordian row description", content: "This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: ImageConstatnts.rowTitleIcon),
        CustomAccordionRowData(title: "Accordian Row 3", subTitle: "Accordian row description", content: "Accordian Row 3 This is the content area for the accordion row. Accordions are a practical way to organise a large amount of non-essential content on a single web page",titleIcon: nil)

        
    ]
    var body: some View {
        RLGAccordianList(rows: $rows, headerTitle: "Accordian title", headerSubtitle: "According to the definition", icon: ImageConstatnts.listTitleIcon)
    }
}

#Preview {
    CustomContentView()
}
