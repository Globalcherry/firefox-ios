/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared
import WebKit

protocol PrintHelperDelegate: class {
    func printHelper(printHelper: PrintHelper, didRequestToPrintTab tab: Browser)
}

class PrintHelper: BrowserHelper {
    weak var delegate: PrintHelperDelegate?
    private weak var browser: Browser?

    class func name() -> String {
        return "PrintHelper"
    }

    required init(browser: Browser) {
        self.browser = browser
        if let path = NSBundle.mainBundle().pathForResource("PrintHelper", ofType: "js"), source = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String {
            let userScript = WKUserScript(source: source, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: false)
            browser.webView!.configuration.userContentController.addUserScript(userScript)
        }
    }

    func scriptMessageHandlerName() -> String? {
        return "printHandler"
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let browser = browser {
            delegate?.printHelper(self, didRequestToPrintTab: browser)
        }
    }
}