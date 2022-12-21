
import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    //MARK: VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        //start URl
        loadWebPage("https://www.gngs.co.jp/")
        preBtn.isEnabled = false
        nextBtn.isEnabled = false
    }
    
    var lastOffsetY :CGFloat = 0
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var preBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
        
    
    @IBAction func preAction(_ sender: Any) {
        webView.goBack()
        
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        webView.goForward()
    }
        
    //reloadBtn
    @IBAction func reloadAction(_ sender: Any) {
        webView.scrollView.contentOffset.y = 0
        webView.reload()
        
    }
    //URL呼ぶ関数
    func loadWebPage(_ url: String) {
        //myUrlにurl型
        let myUrl = URL(string: url)
        //myRequestにRequest型
        let myRequest = URLRequest(url: myUrl!)
        //load メソッド呼ぶ
        webView.load(myRequest)
    }
    
    //探索が終わったら呼ぶ
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
           preBtn.isEnabled = webView.canGoBack // inEnable = true -> cangoback = true ---> true
           nextBtn.isEnabled = webView.canGoForward // isEnable = true -> canGoForward ---> true
   }
}
extension WebViewController: UIScrollViewDelegate {
    
    // ScrollView Drag Start
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetY = webView.scrollView.contentOffset.y
        
    }
    
    // Scrollをする時
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let hide = webView.scrollView.contentOffset.y > self.lastOffsetY
        self.navigationController?.setToolbarHidden(hide, animated: true)
        toolBar.isHidden = hide
    }
}


