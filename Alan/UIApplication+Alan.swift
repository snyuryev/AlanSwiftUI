//
//  UIApplication+Alan.swift
//  AlanSwiftUI
//
//  Created by Sergey Yuryev on 09.04.2022.
//

import UIKit
import AlanSDK

extension UIApplication {
    
    // MARK: - Vars

    /// Alan button variable association (store var in extension)
    private static let associationAlanButton = ObjectAssociation<AlanButton>()

    /// Alan button variable
    var alanButton: AlanButton? {
        get { return UIApplication.associationAlanButton[self] }
        set { UIApplication.associationAlanButton[self] = newValue }
    }

    /// Alan text box variable association (store var in extension)
    private static let associationAlanText = ObjectAssociation<AlanText>()

    /// Alan text box variable
    var alanText: AlanText? {
        get { return UIApplication.associationAlanText[self] }
        set { UIApplication.associationAlanText[self] = newValue }
    }


    // MARK: - Actions

    /// Add button
    func addAlan() {
        self.setupButton()
        self.setupText()
        self.setupHandlers()
        self.setupLogs()
    }

    /// Send visual state via Alan button
    func sendVisual(_ data: [String: Any]) {
        if let button = self.alanButton {
            button.setVisualState(data)
        }
    }

    /// Play text via Alan button
    func playText(_ text: String) {
        if let button = self.alanButton {
            button.playText(text)
        }
    }

    /// Play data via Alan button
    func playData(_ data: [String: String]) {
        if let button = self.alanButton {
            button.playCommand(data)
        }
    }
    
    /// Activate Alan Button
    func activate() {
        if let button = self.alanButton {
            button.activate()
        }
    }
    
    /// Deactivate Alan Button
    func deactivate() {
        if let button = self.alanButton {
            button.deactivate()
        }
    }

    /// Call method via Alan button
    func call(method: String, params: [String: Any], callback:@escaping ((Error?, String?) -> Void)) {
        if let button = self.alanButton {
            button.callProjectApi(method, withData: params, callback: callback)
        }
    }

    // MARK: - Setup

    fileprivate func setupLogs() {
        /// Set to true to show all Alan SDK logs
         AlanLog.setEnableLogging(false)
    }

    fileprivate func setupButton() {
        guard let root = self.keyWindowPresentedController else {
            return
        }
        guard let view = root.view else {
            return
        }

        // prepare config object with project key
        let config = AlanConfig(key: "af2528090c2f0f15faceb579449bc5142e956eca572e1d8b807a3e2338fdd0dc/stage")

        // create Alan button with config
        self.alanButton = AlanButton(config: config)

        /// check Alan button
        guard let button = self.alanButton else {
            return
        }

        // align button on view
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        let b = NSLayoutConstraint(item: button as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
        let r = NSLayoutConstraint(item: button as Any, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let w = NSLayoutConstraint(item: button as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        let h = NSLayoutConstraint(item: button as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        view.addConstraints([b, r, w, h])
        view.bringSubviewToFront(button)
    }

    fileprivate func setupText() {
        guard let root = self.keyWindowPresentedController else {
            return
        }
        guard let view = root.view else {
            return
        }

        // create text box
        self.alanText = AlanText(frame: CGRect.zero)

        /// check Alan button
        guard let text = self.alanText else {
            return
        }

        // align text on view
        text.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(text)
        let b = NSLayoutConstraint(item: text as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
        let l = NSLayoutConstraint(item: text as Any, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
        let r = NSLayoutConstraint(item: text as Any, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let h = NSLayoutConstraint(item: text as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        view.addConstraints([b, r, l, h])
        view.bringSubviewToFront(text)
    }

    fileprivate func setupHandlers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAlanEvent(_:)), name: .handleEvent, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAlanState(_:)), name: .handleState, object:nil)
    }


    // MARK: - Handlers

    @objc func handleAlanState(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let value = userInfo["onButtonState"] as? Int else {
            return
        }
        guard let state = AlanSDKButtonState(rawValue: value) else {
            return
        }
        
        print("state: \(state)")
        
        switch state {
        case .online:
            break
        default:
            break
        }
    }

    @objc func handleAlanEvent(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let event = userInfo["onEvent"] as? String,
            event == "command",
            let jsonString = userInfo["jsonString"] as? String,
            let data = jsonString.data(using: .utf8),
            let unwrapped = try? JSONSerialization.jsonObject(with: data, options: []),
            let d = unwrapped as? [String: Any],
            let json = d["data"] as? [String: Any],
            let command = json["command"] as? String
        else {
            return
        }

        print("command: \(command)")
    }
}

extension Notification.Name {
    static let handleEvent = Notification.Name("kAlanSDKEventNotification")
    static let handleState = Notification.Name("kAlanSDKAlanButtonStateNotification")
}
