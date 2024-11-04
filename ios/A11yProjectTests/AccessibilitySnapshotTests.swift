//
//  AccessibilitySnapshotTests.swift
//  IdentityGuardTests
//

import React
import AccessibilitySnapshot
import SnapshotTesting
import XCTest

class AccessibilitySnapshotTests: XCTestCase {
    let bridge = RCTBridge(bundleURL: RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index"), moduleProvider: nil, launchOptions: nil)

  
  func testAccessibilitySnapshot() {
    let expectation = expectation(description: "Wait for content to appear")
    let observer = Observer(expectation)
    let profileView = RCTRootView(frame: .init(x: 0, y: 0, width: 400, height: 500),
                                  bridge: bridge!,
                                  moduleName: "MyApp",
                                  initialProperties: nil)
    NotificationCenter.default.addObserver(observer,
                                           selector: #selector(observer.handler),
                                           name: NSNotification.Name("RCTContentDidAppearNotification"),
                                           object: profileView)
    defer {
      NotificationCenter.default.removeObserver(observer)
    }
    
    _ = XCTWaiter.wait(for: [expectation], timeout: 5.0)
    
      assertSnapshot(of: profileView, as: .accessibilityImage)
  }
}

class Observer {
  let expectation: XCTestExpectation
  
  init(_ expectation: XCTestExpectation) {
    self.expectation = expectation
  }
  
  @objc func handler(_ notification: NSNotification) {
    expectation.fulfill()
  }
}
