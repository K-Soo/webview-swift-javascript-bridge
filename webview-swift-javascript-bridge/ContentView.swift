//
//  ContentView.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 2024/02/12.
//

import SwiftUI
import Combine

struct ContentView: View {
  @State private var showLoading = false
  @State private var path: [URL] = []

  @EnvironmentObject var webviewModel: WebViewModel

  var body: some View {
    NavigationStack(path: $path) {
      TabItemsView()
        .navigationDestination(for: URL.self) { destinationPath in // More descriptive name
          Webview(url: destinationPath, showLoading: $showLoading)
            .onAppear {
              print("실행 \(destinationPath)")
            }
            .onDisappear {
              print("종료 \(destinationPath)")
            }
        }
        .navigationDestination(for: String.self) { destinationPath in // More descriptive name
          Text("알람 페이지")
        }
        .onReceive(webviewModel.currentUrl, perform: { value in
          if let url = URL(string: value), !path.contains(url) {
            path.append(url) // Append URL to path
          }
        })


        .toolbar {
          ToolbarItem(placement: .automatic) {
            if let url = URL(string: "http://192.168.200.103:3000") {
              NavigationLink(value: url) {
                Text("마이")
              }
            }
          }
          ToolbarItem(placement: .automatic) {
            NavigationLink(value: "al") {
              Text("알람")
            }
          }
        }
        .navigationTitle("Toolbar")
      //        .toolbar(.hidden, for: .navigationBar)
      //        .toolbarColorScheme(.dark, for: .navigationBar)
    }

  }
}

#Preview {
  ContentView().environmentObject(WebViewModel())
}
