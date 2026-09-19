import UIKit

public class InsurancePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI Elements - ScrollView Container
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Customer Login Card
    private let cardLogin: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.08
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Customer Login"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter details linked to policy to continue"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.47, green: 0.56, blue: 0.61, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tfFullName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "As per policy records"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let tfEmail: UITextField = {
        let tf = UITextField()
        tf.placeholder = "you@example.com"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let tfMobile: UITextField = {
        let tf = UITextField()
        tf.placeholder = "10-digit registered number"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let btnContinue: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.setTitleColor(UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0), for: .normal)
        btn.backgroundColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0) // #D4AF37
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // Login History Ledger
    private let cardHistory: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.08
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let historyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login History"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Records"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.09, green: 0.64, blue: 0.72, alpha: 1.0) // #17A2B8
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableViewHistory: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let emptyHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "No previous login attempts yet."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.56, green: 0.64, blue: 0.68, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var historyItems: [SsoHistoryItem] = []
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadHistory()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistory()
    }
    
    private func setupUI() {
        title = "Insurance Panel"
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(loadHistory))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(cardLogin)
        cardLogin.addSubview(titleCardLabel)
        cardLogin.addSubview(subtitleCardLabel)
        cardLogin.addSubview(tfFullName)
        cardLogin.addSubview(tfEmail)
        cardLogin.addSubview(tfMobile)
        cardLogin.addSubview(btnContinue)
        
        contentView.addSubview(cardHistory)
        cardHistory.addSubview(historyTitleLabel)
        cardHistory.addSubview(badgeLabel)
        cardHistory.addSubview(emptyHistoryLabel)
        cardHistory.addSubview(tableViewHistory)
        
        btnContinue.addTarget(self, action: #selector(validateAndSubmit), for: .touchUpInside)
        
        tableViewHeightConstraint = tableViewHistory.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Login Card Constraints
            cardLogin.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardLogin.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardLogin.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleCardLabel.topAnchor.constraint(equalTo: cardLogin.topAnchor, constant: 18),
            titleCardLabel.leadingAnchor.constraint(equalTo: cardLogin.leadingAnchor, constant: 18),
            
            subtitleCardLabel.topAnchor.constraint(equalTo: titleCardLabel.bottomAnchor, constant: 2),
            subtitleCardLabel.leadingAnchor.constraint(equalTo: titleCardLabel.leadingAnchor),
            
            tfFullName.topAnchor.constraint(equalTo: subtitleCardLabel.bottomAnchor, constant: 16),
            tfFullName.leadingAnchor.constraint(equalTo: cardLogin.leadingAnchor, constant: 18),
            tfFullName.trailingAnchor.constraint(equalTo: cardLogin.trailingAnchor, constant: -18),
            tfFullName.heightAnchor.constraint(equalToConstant: 44),
            
            tfEmail.topAnchor.constraint(equalTo: tfFullName.bottomAnchor, constant: 12),
            tfEmail.leadingAnchor.constraint(equalTo: tfFullName.leadingAnchor),
            tfEmail.trailingAnchor.constraint(equalTo: tfFullName.trailingAnchor),
            tfEmail.heightAnchor.constraint(equalToConstant: 44),
            
            tfMobile.topAnchor.constraint(equalTo: tfEmail.bottomAnchor, constant: 12),
            tfMobile.leadingAnchor.constraint(equalTo: tfFullName.leadingAnchor),
            tfMobile.trailingAnchor.constraint(equalTo: tfFullName.trailingAnchor),
            tfMobile.heightAnchor.constraint(equalToConstant: 44),
            
            btnContinue.topAnchor.constraint(equalTo: tfMobile.bottomAnchor, constant: 18),
            btnContinue.leadingAnchor.constraint(equalTo: tfFullName.leadingAnchor),
            btnContinue.trailingAnchor.constraint(equalTo: tfFullName.trailingAnchor),
            btnContinue.heightAnchor.constraint(equalToConstant: 48),
            btnContinue.bottomAnchor.constraint(equalTo: cardLogin.bottomAnchor, constant: -18),
            
            // History Card Constraints
            cardHistory.topAnchor.constraint(equalTo: cardLogin.bottomAnchor, constant: 16),
            cardHistory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardHistory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardHistory.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            historyTitleLabel.topAnchor.constraint(equalTo: cardHistory.topAnchor, constant: 18),
            historyTitleLabel.leadingAnchor.constraint(equalTo: cardHistory.leadingAnchor, constant: 18),
            
            badgeLabel.trailingAnchor.constraint(equalTo: cardHistory.trailingAnchor, constant: -18),
            badgeLabel.centerYAnchor.constraint(equalTo: historyTitleLabel.centerYAnchor),
            badgeLabel.widthAnchor.constraint(equalToConstant: 90),
            badgeLabel.heightAnchor.constraint(equalToConstant: 26),
            
            emptyHistoryLabel.topAnchor.constraint(equalTo: historyTitleLabel.bottomAnchor, constant: 24),
            emptyHistoryLabel.leadingAnchor.constraint(equalTo: cardHistory.leadingAnchor, constant: 18),
            emptyHistoryLabel.trailingAnchor.constraint(equalTo: cardHistory.trailingAnchor, constant: -18),
            emptyHistoryLabel.bottomAnchor.constraint(equalTo: cardHistory.bottomAnchor, constant: -24),
            
            tableViewHistory.topAnchor.constraint(equalTo: historyTitleLabel.bottomAnchor, constant: 14),
            tableViewHistory.leadingAnchor.constraint(equalTo: cardHistory.leadingAnchor, constant: 6),
            tableViewHistory.trailingAnchor.constraint(equalTo: cardHistory.trailingAnchor, constant: -6),
            tableViewHistory.bottomAnchor.constraint(equalTo: cardHistory.bottomAnchor, constant: -12),
            tableViewHeightConstraint
        ])
    }
    
    private func setupTableView() {
        tableViewHistory.dataSource = self
        tableViewHistory.delegate = self
        tableViewHistory.register(SsoHistoryCell.self, forCellReuseIdentifier: SsoHistoryCell.identifier)
    }
    
    @objc private func loadHistory() {
        let session = UserSession.shared
        APIService.shared.fetchSsoHistory(userId: session.userId, token: session.apiToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.historyItems = items
                    self?.badgeLabel.text = "\(items.count) Records"
                    self?.emptyHistoryLabel.isHidden = !items.isEmpty
                    self?.tableViewHistory.isHidden = items.isEmpty
                    self?.tableViewHistory.reloadData()
                    self?.tableViewHeightConstraint.constant = CGFloat(items.count * 115)
                case .failure(_):
                    self?.emptyHistoryLabel.isHidden = false
                    self?.tableViewHistory.isHidden = true
                }
            }
        }
    }
    
    @objc private func validateAndSubmit() {
        guard let name = tfFullName.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            showAlert(title: "Required", message: "Please enter customer full name.")
            return
        }
        
        guard let email = tfEmail.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty, email.contains("@") else {
            showAlert(title: "Required", message: "Please enter a valid email address.")
            return
        }
        
        guard let mobile = tfMobile.text?.trimmingCharacters(in: .whitespaces), mobile.count == 10, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: mobile)) else {
            showAlert(title: "Required", message: "Please enter a valid 10-digit mobile number.")
            return
        }
        
        performSso(fullName: name, email: email, mobile: mobile)
    }
    
    private func performSso(fullName: String, email: String, mobile: String) {
        btnContinue.isEnabled = false
        btnContinue.setTitle("Processing SSO...", for: .normal)
        
        let session = UserSession.shared
        APIService.shared.performSsoLogin(fullName: fullName, email: email, mobile: mobile, userId: session.userId, token: session.apiToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.btnContinue.isEnabled = true
                self?.btnContinue.setTitle("Continue", for: .normal)
                
                switch result {
                case .success(let redirectURL):
                    self?.tfFullName.text = ""
                    self?.tfEmail.text = ""
                    self?.tfMobile.text = ""
                    self?.loadHistory()
                    
                    let webVC = WebActionViewController(url: redirectURL, title: "Insurance - \(fullName)")
                    let navVC = UINavigationController(rootViewController: webVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: nil)
                    
                case .failure(let error):
                    self?.showAlert(title: "Connection Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SsoHistoryCell.identifier, for: indexPath) as? SsoHistoryCell else {
            return UITableViewCell()
        }
        
        let item = historyItems[indexPath.row]
        cell.configure(with: item, index: indexPath.row)
        
        cell.onViewTapped = { [weak self] in
            let name = item.displayName
            let email = item.customerEmail ?? ""
            let mobile = item.customerMobile ?? ""
            
            self?.tfFullName.text = name
            self?.tfEmail.text = email
            self?.tfMobile.text = mobile
            self?.performSso(fullName: name, email: email, mobile: mobile)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
