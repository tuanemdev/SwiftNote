//
//  CustomTabbarView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 13/05/2023.
//

import SwiftUI

struct CustomTabbarView: View {
    
    @State private var activeTabItem: TabItem = .home
    @State private var activeSubTab: String = "service 1"
    @Namespace private var animation
    @State private var tabItemPosition: CGPoint = .zero
    
    init() { UITabBar.appearance().isHidden = true } // Fix Bug in iOS 16
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTabItem) {
                Text("Home")
                    .tag(TabItem.home)
                    .toolbar(.hidden, for: .tabBar)
                
                Group {
                    TabView(selection: $activeSubTab) {
                        Text("Services 1")
                            .tag("service 1")
                            .toolbar(.hidden, for: .tabBar)
                        
                        Text("Services 2")
                            .tag("service 2")
                            .toolbar(.hidden, for: .tabBar)
                        
                        Text("Services 3")
                            .tag("service 3")
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
                .tag(TabItem.services)
                
                Text("Partners")
                    .tag(TabItem.partners)
                    .toolbar(.hidden, for: .tabBar)
                    .onTapGesture {
                        activeSubTab = "service 2"
                    }
                
                Text("Activity")
                    .tag(TabItem.activity)
                    .toolbar(.hidden, for: .tabBar)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            customTabbar()
        }
    }
    
    @ViewBuilder
    private func customTabbar(_ activeTint: Color = .blue, _ inactiveTint: Color = .teal) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tabItem in
                TabItemView(
                    activeTint: activeTint,
                    inactiveTint: inactiveTint,
                    tabItem: tabItem,
                    animation: animation,
                    activeTabItem: $activeTabItem,
                    position: $tabItemPosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background {
            TabItemShape(midPoint: tabItemPosition.x)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: activeTint.opacity(0.5), radius: 5, x: 0, y: -5)
                .padding(.top, 25)
        }
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTabItem)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: tabItemPosition)
    }
}

struct CustomTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabbarView()
    }
}

struct TabItemView: View {
    
    var activeTint: Color
    var inactiveTint: Color
    var tabItem: TabItem
    var animation: Namespace.ID
    @Binding var activeTabItem: TabItem
    @Binding var position: CGPoint
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tabItem.systemImage)
                .font(.title2)
                .foregroundColor(tabItem == activeTabItem ? .white : inactiveTint)
                .frame(width: tabItem == activeTabItem ? 58 : 35, height: tabItem == activeTabItem ? 58 : 35)
                .background {
                    if tabItem == activeTabItem {
                        Circle()
                            .fill(activeTint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETABITEM", in: animation)
                    }
                }
            
            Text(tabItem.rawValue)
                .font(.caption)
                .foregroundColor(tabItem == activeTabItem ? activeTint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition { rect in
            if tabItem == activeTabItem {
                position.x = rect.midX
            }
        }
        .onTapGesture {
            activeTabItem = tabItem
        }
    }
}
