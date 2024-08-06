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
  @EnvironmentObject var webviewModel: WebViewModel


  func createWKWebConfig() -> WKWebViewConfiguration {
    let wkWebConfig = WKWebViewConfiguration()
    let userContentController = WKUserContentController()
        let preferences = WKPreferences()

    // 메시지 핸들러 추가
    userContentController.add(self.makeCoordinator(), name: "IOSbridge")

    // JavaScript 실행을 허용 여부 Default: true
    wkWebConfig.defaultWebpagePreferences.allowsContentJavaScript = true
    // 자바스크립트가 새 창을 열 수 있는지 확인
    preferences.javaScriptCanOpenWindowsAutomatically = true

    wkWebConfig.preferences = preferences
    wkWebConfig.userContentController = userContentController


    return wkWebConfig
  }


  func makeUIView(context: Context) -> WKWebView {
    let webview = WKWebView(frame: .zero, configuration: createWKWebConfig())



    // 사용자가 웹 뷰에서 이전 페이지로 이동하거나 앞으로 이동하기 위해 제스처를 사용할 수 있도록 허용하는지 여부를 제어합니다. Default: false
    webview.allowsBackForwardNavigationGestures = false
    // WKWebView의 스크롤 뷰가 최상단 또는 최하단에 도달했을 때 바운스(탄성 효과)를 허용할지를 제어합니다. Default: true
    webview.scrollView.bounces = true
    // 웹뷰에서 스크롤뷰의 스크롤 기능을 활성화할지 여부를 결정합니다. Default: true
    webview.scrollView.isScrollEnabled = true
    // 수직 스크롤이 불가능한 경우에도 바운스 효과를 허용할지 여부를 결정합니다. Default: false
    webview.scrollView.alwaysBounceVertical = false
    // 배경을 투명하게 설정
    // webview.isOpaque = false
    // webview.backgroundColor = UIColor.white

    //wkwebview의 델리겟 연결을 위한 코디네이터 설정 Coordinator는 UIKit -> SwiftUI로의 데이터 전달 (= delegate 역할)
    webview.navigationDelegate = context.coordinator
    webview.uiDelegate = context.coordinator

    webview.load(URLRequest(url: url))
    return webview
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {

  }

  func makeCoordinator() -> WebviewCoordinator {
    return WebviewCoordinator(didStart: { showLoading = true }, didFinish: { showLoading = false }, webviewModel: webviewModel)
  }
}

class WebviewCoordinator: NSObject {
  var didStart: () -> Void
  var didFinish: () -> Void
  var webviewModel : WebViewModel

  init (didStart: @escaping () -> Void, didFinish: @escaping () -> Void, webviewModel: WebViewModel ) {
    self.didStart = didStart
    self.didFinish = didFinish
    self.webviewModel = webviewModel
  }
}


//MARK: - WKNavigationDelegate
extension WebviewCoordinator : WKNavigationDelegate {

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
    print("decidePolicyFor-preferences-decisionHandler")
    /** @abstract 내비게이션을 허용할지 취소할지를 결정합니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigationAction 내비게이션 요청을 트리거하는 동작에 대한 설명적인 정보입니다.
     @param preferences 웹 페이지 기본 환경 설정입니다. 이는 WKWebViewConfiguration의 defaultWebpagePreferences를 설정하여 변경할 수 있습니다.
     @param decisionHandler 내비게이션을 허용하거나 취소할 정책 결정 핸들러입니다. 인자로는 열거형 WKNavigationActionPolicy의 상수 중 하나와 WKWebpagePreferences의 인스턴스가 전달됩니다.
     @discussion 이 메서드를 구현하면 -webView:decidePolicyForNavigationAction:decisionHandler:가 호출되지 않습니다.
     */
    decisionHandler(.allow, preferences)
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    print("decidePolicyFor-decisionHandler")
    /** @abstract 내비게이션 응답이 알려진 후에 내비게이션을 허용할지 취소할지를 결정합니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigationResponse 내비게이션 응답에 대한 설명적인 정보입니다.
     @param decisionHandler 내비게이션을 허용하거나 취소할 결정 핸들러입니다. 이 인자는 열거형 WKNavigationResponsePolicy의 상수 중 하나입니다.
     @discussion 이 메서드를 구현하지 않으면, 웹 뷰가 보여줄 수 있다면 웹 뷰가 응답을 허용합니다.
     */
    // 스킴제어 리다이렉트 가능
    decisionHandler(.allow)
  }


  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("didStartProvisionalNavigation")
    /** @abstract 메인 프레임 내비게이션이 시작될 때 호출됩니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigation 내비게이션입니다.
     */
  }

  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    print("didFailProvisionalNavigation")
    /** @abstract 메인 프레임의 데이터 로드를 시작하는 동안 오류가 발생했을 때 호출됩니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigation 내비게이션입니다.
     @param error 발생한 오류입니다.
     */
  }

  func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    print("didReceiveServerRedirectForProvisionalNavigation")
    /** @abstract 메인 프레임에 대한 서버 리디렉션이 수신되었을 때 호출됩니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigation 내비게이션입니다.
     */
  }

  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    print("didCommit")
    /** @abstract 메인 프레임에 대한 콘텐츠가 도착하기 시작할 때 호출됩니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigation 내비게이션입니다.
     */
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("didFinish")

    webView.evaluateJavaScript("window.isIOSWebView = true;")

    /** @abstract 메인 프레임 내비게이션이 완료되었을 때 호출됩니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigation 내비게이션입니다.
     */

    //웹뷰 title 가져올수있음, evaluateJavaScript로 자바스크립트 호출?
    //"window.dispatchEvent(nativeToJsEventCall)" << next.js useEffect 작동 O
    //"javascript:window.NativeInterface.helloWorld('\(message)');" << next.js useEffect 작동 O
    //"funcName();" << next.js에서 스크립트 태그넣어서 작동 O
    //"nativeToJsEventCall('\(message)')"



    //    webView.evaluateJavaScript("javascript:window.dispatchEvent(sayHello)") { (result, error) in
    //      print("result", result)
    //      print("error", error)
    //    }
    //
    //    webView.evaluateJavaScript("javascript:window.NativeInterface.helloWorld()") { result, error in
    ////      print("result", result)
    ////      print("error", error)
    //    }

  }



  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("didFail")
    /** @abstract 메인 프레임 내비게이션 중에 오류가 발생했을 때 호출됩니다.
     @param webView 델리게이트 메서드를 호출하는 웹 뷰입니다.
     @param navigation 내비게이션입니다.
     @param error 발생한 오류입니다.
     */
  }


  // 호출조건 target="_blank, window.open()
  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    //웹뷰에서 외부링크 인터렉션 감지됨. _blank가 없으면 함수실행X
    print("createWebViewWith")

    guard navigationAction.targetFrame == nil else {
      // 타겟 프레임이 존재하면 기본적으로 현재 웹뷰에서 열립니다.
      print("targetFrame", navigationAction.targetFrame ?? "nil 아님")
      return nil
    }

    guard let url = navigationAction.request.url else { return nil }

    guard UIApplication.shared.canOpenURL(url) else { return nil }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)

    return nil
  }


  @available(iOS 15.0, *)
  func webView(_ webView: WKWebView, respondTo challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
    print("URLAuthenticationChallenge - 웹 뷰가 인증 도전에 응답해야 할 때 호출됩니다.")
    /** @abstract 웹 뷰가 인증 도전에 응답해야 할 때 호출됩니다. (HTTPS 외부링크일경우에만 해당 함수를 탐. HTTP는 호출안됨)
     @param webView 인증 도전을 받은 웹 뷰입니다.
     @param challenge 인증 도전입니다.
     @param completionHandler 도전에 응답하기 위해 호출해야 하는 완료 핸들러입니다.
     disposition 인자는 NSURLSessionAuthChallengeDisposition 열거형의 상수 중 하나입니다.
     disposition이 NSURLSessionAuthChallengeUseCredential인 경우,
     credential 인자는 사용할 자격 증명을 나타내며, 자격 증명 없이 계속 진행하는 경우 nil입니다.
     @discussion 이 메서드를 구현하지 않으면, 웹 뷰가 인증 도전에 NSURLSessionAuthChallengeRejectProtectionSpace
     disposition으로 응답합니다.
     */
    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
       let serverTrust = challenge.protectionSpace.serverTrust {
      // 서버 인증서를 강제로 신뢰
      let credential = URLCredential(trust: serverTrust)
      return (.useCredential, credential)
    }
    return (.cancelAuthenticationChallenge, nil)
  }

  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    print("웹 뷰의 웹 콘텐츠 프로세스가 종료될 때 호출됩니다.")
    /** @abstract 웹 뷰의 웹 콘텐츠 프로세스가 종료될 때 호출됩니다.
     @param webView 웹 뷰의 기본 웹 콘텐츠 프로세스가 종료된 웹 뷰입니다.
     */
  }


  func webViewDidClose(_ webView: WKWebView) {
    print("webViewDidClose")
  }

  func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
    print("navigationAction - didBecome")
    /*
     @abstract WKNavigationActionPolicyDownload를 사용한 후 호출됩니다.
     @param webView 다운로드를 생성한 웹 뷰입니다.
     @param navigationAction 다운로드로 전환되는 작업입니다.
     @param download 다운로드입니다.
     @discussion 다운로드는 진행 상황에 대한 업데이트를 받기 위해 해당 델리게이트가 설정되어야 합니다.
     */
  }

  func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
    print("navigationResponse - didBecome")
    /*
     @abstract WKNavigationResponsePolicyDownload를 사용한 후 호출됩니다.
     @param webView 다운로드를 생성한 웹 뷰입니다.
     @param navigationResponse 다운로드로 전환되는 응답입니다.
     @param download 다운로드입니다.
     @discussion 다운로드는 진행 상황에 대한 업데이트를 받기 위해 해당 델리게이트가 설정되어야 합니다.
     */
  }
}

//MARK: - WKUIDelegate
extension WebviewCoordinator: WKUIDelegate {

  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    print("runJavaScriptAlertPanelWithMessage - \(message)")
    completionHandler()
  }
}

//MARK: - WKScriptMessageHandler
extension WebviewCoordinator: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print("WKScriptMessage name", message.name)

    // 메시지 본문 파싱
      guard let messageBody = parseMessageBody(message.body) else {
          print("Failed to parse message body")
          return
      }

    print("messageBody", messageBody)

    guard let type = messageBody["type"] as? String else {
      print("Invalid message format")
      return
    }

    switch type {
    case "ROUTER_EVENT":
      if let path = messageBody["path"] as? String {
        handleRouterEvent(path: path)
      } else {
        print("Invalid path in ROUTER_EVENT")
      }
    default:
      print("Unknown event type: \(type)")
    }
  }
}

// JSON 문자열을 [String: Any]로 파싱하는 함수
private func parseMessageBody(_ body: Any) -> [String: Any]? {
    guard let messageString = body as? String,
          let data = messageString.data(using: .utf8) else {
        print("Invalid message body: Cannot convert to Data")
        return nil
    }

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        } else {
            print("Invalid JSON format")
        }
    } catch {
        print("Error parsing JSON:", error)
    }
    return nil
}


extension WebviewCoordinator {
  func handleRouterEvent(path: String) {

    webviewModel.currentUrl.send(path)

    // ROUTER_EVENT 타입 처리
    print("Handling ROUTER_EVENT with path: \(path)")
    // 이곳에 해당 path를 사용한 네이티브 작업을 수행합니다.
    // 예를 들어, 웹뷰에서 다른 페이지로 이동하거나, 네이티브 UI 업데이트 등을 수행할 수 있습니다.
  }


}
