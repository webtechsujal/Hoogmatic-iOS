import UIKit
import WebKit
import UniformTypeIdentifiers

public class WebActionViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIDocumentPickerDelegate {
    
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var targetURL: URL?
    private var customTitle: String = "Service Application"
    private var isFullPage: Bool = false
    
    // Document Upload Callback
    private var documentPickerCompletion: (([URL]?) -> Void)?
    
    public init(url: URL, title: String = "Service Application", isFullPage: Bool = true) {
        self.targetURL = url
        self.customTitle = title
        self.isFullPage = isFullPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        loadRequest()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        title = customTitle
        
        // Navigation bar styling
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapReload))
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        // Custom CSS Rules
        let cssRules: String
        if isFullPage {
            cssRules = ".main-header, .main-sidebar, .main-footer { display: none !important; } .content-wrapper { margin-left: 0px !important; margin-top: 0px !important; }"
        } else {
            cssRules = ".row.p-3, div.card.card-success, .main-header, .main-sidebar, .main-footer, .content-header, .card-header, marquee, header, footer { display: none !important; } .content-wrapper { margin-left: 0px !important; padding-top: 10px !important; margin-top: 0px !important; } body { padding-top: 0px !important; }"
        }
        
        // Inject JS to force window.open and target="_blank" to load in-app
        let jsScript = """
        window.open = function(url) { if(url) { window.location.href = url; } return window; };
        var fixTargets = function() {
           var forms = document.querySelectorAll('form');
           for (var i = 0; i < forms.length; i++) { forms[i].setAttribute('target', '_self'); }
           var links = document.querySelectorAll('a');
           for (var j = 0; j < links.length; j++) { if (links[j].getAttribute('target') === '_blank') { links[j].setAttribute('target', '_self'); } }
        };
        fixTargets();
        if (!window._idy_target_interval) { window._idy_target_interval = setInterval(fixTargets, 300); }
        var style = document.getElementById('idy-app-hide-style');
        if (!style) {
           style = document.createElement('style');
           style.id = 'idy-app-hide-style';
           style.innerHTML = '\(cssRules)';
           document.head.appendChild(style);
        }
        """
        
        let userScript = WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(userScript)
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0) // #D4AF37
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func loadRequest() {
        guard let url = targetURL else { return }
        
        let token = UserSession.shared.apiToken
        if !token.isEmpty, let cookie = HTTPCookie(properties: [
            .domain: ".hoogmatic.in",
            .path: "/",
            .name: "login_token",
            .value: token,
            .secure: "TRUE"
        ]) {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) { [weak self] in
                var request = URLRequest(url: url)
                request.setValue("login_token=\(token); Path=/; Domain=.hoogmatic.in", forHTTPHeaderField: "Cookie")
                self?.webView.load(request)
            }
        } else {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = webView.estimatedProgress >= 1.0
        }
    }
    
    @objc private func didTapBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func didTapReload() {
        webView.reload()
    }
    
    // MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        let urlString = url.absoluteString.lowercased()
        
        // Handle PDF downloads natively
        if urlString.hasSuffix(".pdf") || urlString.contains("download") {
            downloadPDF(url: url)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    // MARK: - WKUIDelegate (Window.open & Target=_blank interception)
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || !navigationAction.targetFrame!.isMainFrame {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    // MARK: - Document Chooser for File Uploads (<input type="file">)
    public func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
        self.documentPickerCompletion = completionHandler
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item, .pdf, .image], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = parameters.allowsMultipleSelection
        present(picker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        documentPickerCompletion?(urls)
        documentPickerCompletion = nil
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        documentPickerCompletion?(nil)
        documentPickerCompletion = nil
    }
    
    private func downloadPDF(url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { [weak self] localURL, response, error in
            guard let localURL = localURL, error == nil else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Download Error", message: error?.localizedDescription ?? "Failed to download document.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
                return
            }
            
            let fileManager = FileManager.default
            let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = docsURL.appendingPathComponent(url.lastPathComponent)
            
            try? fileManager.removeItem(at: destinationURL)
            do {
                try fileManager.copyItem(at: localURL, to: destinationURL)
                DispatchQueue.main.async {
                    let activityVC = UIActivityViewController(activityItems: [destinationURL], applicationActivities: nil)
                    self?.present(activityVC, animated: true)
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
        task.resume()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}
