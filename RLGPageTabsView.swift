//
//  SwiftUIView.swift
//  DesignSystem-Native-iOS
//
//  Created by Praveen Reddy on 08/10/25.
//

import SwiftUI
import Combine

public class TabViewModel: ObservableObject {
    @Published public var selectedIndex: Int = 0
    public init() {}
}
public struct TabItem: Identifiable {
    public let id = UUID()
    public let title: String
    public init(title: String) {
        self.title = title
    }
}

public struct RLGPageTabsView: View {
    @ObservedObject public var viewModel: TabViewModel
    public let items: [TabItem]
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .body) private var iconHeight = 14
    public var onSelectionChanged: ((Int) -> Void)? = nil
    public var horizontalPadding: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    public var topPadding: CGFloat = CGFloat(StyleDictionarySize.spacing400)
    public var leftPadding: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    public var rightPadding: CGFloat = CGFloat(StyleDictionarySize.spacing300)
    public var showLeftButton: Bool = true
    public var showRightButton: Bool = true
    
    public init(
        viewModel: TabViewModel,
        items: [TabItem],
        horizontalPadding: CGFloat = 8,
        topPadding: CGFloat = 8,
        leftPadding: CGFloat = 0,
        rightPadding: CGFloat = 0,
        showLeftButton: Bool = true,
        showRightButton: Bool = true,
        onSelectionChanged: ((Int) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.items = items
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.showLeftButton = showLeftButton
        self.showRightButton = showRightButton
        self.onSelectionChanged = onSelectionChanged
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollProxy in
                HStack(spacing: horizontalPadding) {
                    //  Left Arrow Button
                    if showLeftButton && items.count > 2 {
                        Button(action: {
                            if viewModel.selectedIndex > 0 {
                                withAnimation(.easeInOut) {
                                    viewModel.selectedIndex -= 1
                                    scrollProxy.scrollTo(viewModel.selectedIndex, anchor: .center)
                                }
                            }
                        }) {
                            Image(
                                viewModel.selectedIndex > 0
                                ? (colorScheme == .dark ? ImageConstatnts.leftArrowDark : ImageConstatnts.leftArrowLight)
                                : (colorScheme == .dark ? ImageConstatnts.disableLeftDark : ImageConstatnts.disableLeftLight),
                                bundle: .module
                            )
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconHeight, height: iconHeight)
                            .accessibilityLabel(
                                Text(
                                    viewModel.selectedIndex > 0
                                    ? "\(StringConstants.previousButtonEnabled), \(StringConstants.accessbilityLbl_DoubleTapTo)"
                                    : StringConstants.previousButtonNotEnabled
                                )
                            )
                            .accessibilityIdentifier("\(StringConstants.leftArrowButton)")
                        }
                        .disabled(viewModel.selectedIndex == 0)
                        .accessibilityRemoveTraits([.isImage, .isButton])
                    }
                    
                    if items.count == 2 {
                        HStack(spacing: 0) {
                            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        viewModel.selectedIndex = index
                                    }
                                }) {
                                    VStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                                        Text(item.title)
                                            .font(.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead)))
                                            .fontWeight(viewModel.selectedIndex == index ? .bold : .regular)
                                            .foregroundColor(viewModel.selectedIndex == index ? selectedTextColor : unselectedTextColor)
                                            .lineLimit(1)
                                            .baselineOffset(2)
                                            .padding(.top, CGFloat(StyleDictionarySize.spacing400))
                                        Capsule()
                                            .fill(viewModel.selectedIndex == index ? underlineColor : Color.clear)
                                            .frame(height: 2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .contentShape(Rectangle())
                                }
                                .accessibilityRemoveTraits(.isButton)
                                .accessibilityLabel(Text(item.title))
                                .accessibilityValue(Text(" \(StringConstants.tabString) \(index + 1) \(StringConstants.of) \(items.count)"))
                                .accessibilityHint(viewModel.selectedIndex == index ? "\(StringConstants.selectedString)" : StringConstants.accessbilityLbl_DoubleTapTo)
                                .accessibilityIdentifier("\(StringConstants.tabButton)\(index)")
                            }
                        }
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: CGFloat(StyleDictionarySize.spacing400)) {
                                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            viewModel.selectedIndex = index
                                            scrollProxy.scrollTo(index, anchor: .center)
                                        }
                                    }) {
                                        VStack(spacing: CGFloat(StyleDictionarySize.spacing200)) {
                                            Text(item.title)
                                                .font(.custom(StyleDictionaryTypography.typographyFamilyTitle, size: CGFloat(StyleDictionarySize.typographySizeSubhead)))
                                                .fontWeight(viewModel.selectedIndex == index ? .bold : .regular)
                                                .foregroundColor(viewModel.selectedIndex == index ? selectedTextColor : unselectedTextColor)
                                                .baselineOffset(2)
                                                .padding(.top, CGFloat(StyleDictionarySize.spacing400))
                                            Capsule()
                                                .fill(viewModel.selectedIndex == index ? underlineColor : Color.clear)
                                                .frame(height: 2)
                                        }
                                        .frame(minWidth: 80)
                                        .contentShape(Rectangle())
                                    }
                                    .id(index)
                                    .accessibilityRemoveTraits(.isButton)
                                    .accessibilityLabel(Text(item.title))
                                    .accessibilityValue(Text(" \(StringConstants.tabString) \(index + 1) \(StringConstants.of) \(items.count)"))
                                    .accessibilityHint(viewModel.selectedIndex == index ? "\(StringConstants.selectedString)" : StringConstants.accessbilityLbl_DoubleTapTo)
                                    .accessibilityIdentifier("\(StringConstants.tabButton)\(index)")
                                }
                            }
                        }
                    }
                    // Right Arrow Button
                    if showRightButton && items.count > 2 {
                        Button(action: {
                            if viewModel.selectedIndex < items.count - 1 {
                                withAnimation(.easeInOut) {
                                    viewModel.selectedIndex += 1
                                    scrollProxy.scrollTo(viewModel.selectedIndex, anchor: .center)
                                }
                            }
                        }) {
                            
                            Image(viewModel.selectedIndex < items.count - 1
                                  ? (colorScheme == .dark ? ImageConstatnts.rightArrowDark : ImageConstatnts.rightArrowLight)
                                  : (colorScheme == .dark ? ImageConstatnts.disableRightDark : ImageConstatnts.disableRightLight), bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconHeight, height: iconHeight)
                            .accessibilityLabel(viewModel.selectedIndex < items.count - 1 ?  Text("\(StringConstants.nextButtonEnabled),\(StringConstants.accessbilityLbl_DoubleTapTo)") : Text(StringConstants.nextButtonNotEnabled))
                            .accessibilityIdentifier("\(StringConstants.rightArrowButton)")
                        }
                        .accessibilityRemoveTraits([.isImage, .isButton])
                        .disabled(viewModel.selectedIndex == items.count - 1)
                    }
                }
                .onAppear {
                    clampSelectedIndex()
                    scrollToSelected(scrollProxy)
                }
                .onChange(of: viewModel.selectedIndex) { _ in
                    clampSelectedIndex()
                    scrollToSelected(scrollProxy)
                    onSelectionChanged?(viewModel.selectedIndex)
                }
                .onChange(of: items.count) { _ in
                    clampSelectedIndex()
                    scrollToSelected(scrollProxy)
                }
            }
            .padding(.top, topPadding)
            .padding(.leading, leftPadding)
            .padding(.trailing, rightPadding)
            
            Rectangle()
                .fill(dividerColor)
                .frame(height: 1.0)
        }
    }
    
    // MARK: - Helpers
    private func clampSelectedIndex() {
        guard !items.isEmpty else {
            viewModel.selectedIndex = 0
            return
        }
        viewModel.selectedIndex = min(max(0, viewModel.selectedIndex), items.count - 1)
    }
    private func scrollToSelected(_ proxy: ScrollViewProxy) {
        guard items.indices.contains(viewModel.selectedIndex), items.count > 2 else { return }
        withAnimation(.easeInOut) {
            proxy.scrollTo(viewModel.selectedIndex, anchor: .center)
        }
    }
    private var selectedTextColor: Color {
        colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.rlTeal100)
    }
    private var unselectedTextColor: Color {
        colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral100) : Color(StyleDictionaryColor.colourTabsText)
    }
    private var underlineColor: Color {
        colorScheme == .dark ? Color(StyleDictionaryColor.colourTabsStrokeActiveDark) : Color(StyleDictionaryColor.secondary80)
    }
    private var dividerColor: Color {
        colorScheme == .dark ? Color(StyleDictionaryColor.darkNeutral60) : Color(StyleDictionaryColor.lightNeutral30)
    }
}

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    private var tabViewModel = TabViewModel()
    let items: [TabItem] = [
        TabItem(title: "Label"),
        TabItem(title: "Label"),
        TabItem(title: "Label"),
        TabItem(title: "Label")
    ]
    
    var body: some View {
        RLGPageTabsView(
            viewModel: tabViewModel,
            items: items,
            horizontalPadding: CGFloat(StyleDictionarySize.spacing300),
            topPadding: CGFloat(StyleDictionarySize.spacing400),
            leftPadding: CGFloat(StyleDictionarySize.spacing300),
            rightPadding: CGFloat(StyleDictionarySize.spacing300),
            showLeftButton: true,
            showRightButton: true
        )
        
        TabView(selection: $selectedIndex) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack {
                    Text("Content of  \(item.title) ")
                        .font(.title)
                        .padding()
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // hides default page indicator
    }
}

#Preview {
    ContentView()
}
