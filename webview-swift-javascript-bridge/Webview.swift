//
//  Webview.swift
//  webview-swift-javascript-bridge
//
//  Created by admin on 2024/02/12.
//

import Foundation
import SwiftUI
import WebKit
import UIKit
import Foundation

struct Webview: UIViewRepresentable {
  let url: URL
  @Binding var showLoading: Bool

  func createWKWebConfig() -> WKWebViewConfiguration {
    let preferences = WKPreferences()
    let wkWebConfig = WKWebViewConfiguration()
    let userContentController = WKUserContentController()

    //message handler
    userContentController.add(self.makeCoordinator(), name: "signOutChannel")

//    wkWebConfig.defaultWebpagePreferences.allowsContentJavaScript = true
    preferences.javaScriptCanOpenWindowsAutomatically = true

//    wkWebConfig.preferences = preferences
    wkWebConfig.userContentController = userContentController

    return wkWebConfig
  }


  func makeUIView(context: Context) -> WKWebView {
    let webview = WKWebView(frame: .zero, configuration: createWKWebConfig())

    webview.navigationDelegate = context.coordinator
    webview.uiDelegate = context.coordinator

    webview.load(URLRequest(url: url))
    return webview
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {

  }

  func makeCoordinator() -> WebviewCoordinator {
    return WebviewCoordinator(didStart: { showLoading = true }) { showLoading = false }
  }
}

class WebviewCoordinator: NSObject {
  var didStart: () -> Void
  var didFinish: () -> Void

  init (didStart: @escaping () -> Void, didFinish: @escaping () -> Void ) {
    self.didStart = didStart
    self.didFinish = didFinish
  }
}


//MARK: - WKNavigationDelegate
extension WebviewCoordinator : WKNavigationDelegate {

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

  }

  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

  }

  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

  }

  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {

  }

  func webViewDidClose(_ webView: WKWebView) {

  }
}

//MARK: - WKUIDelegate
extension WebviewCoordinator: WKUIDelegate {

  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

  }
}

//MARK: - WKScriptMessageHandler
extension WebviewCoordinator: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print("WKScriptMessage body", message.body)
    print("WKScriptMessage name", message.name)
  }
}
