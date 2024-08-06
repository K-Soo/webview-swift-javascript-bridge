//
//  TabView.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 8/4/24.
//

import SwiftUI

struct TabItemsView: View {
  @State private var selection = 0
  @State private var showLoading = false



  var body: some View {
    TabView(selection: $selection) {
      HomeView()
        .tabItem {
          Image(systemName: "house.fill")
          Text("홈으로")
        }
        .tag(0)

      Webview(url: URL(string: "http://192.168.200.103:3000")!, showLoading: $showLoading)
        .tabItem {
          Image(systemName: "bookmark.circle.fill")
          Text("북마크")
        }
        .tag(1)

      Text("세번째 뷰")
        .font(.system(size: 30))
        .tabItem {
          Image(systemName: "video.circle.fill")
          Text("비디오")
        }
        .tag(2)
    }
  }
}

#Preview {
  TabItemsView()
}
