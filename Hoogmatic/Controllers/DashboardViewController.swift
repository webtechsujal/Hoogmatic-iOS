import UIKit

public class DashboardViewController: UIViewController {
    
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
    
    // Header Header View
    private let headerCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0) // #1E2838
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome, Sujal Kumar"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "DSA Partner | ID: 82"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.7, green: 0.75, blue: 0.8, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let walletTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Wallet Balance"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let walletAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "₹ 0.00"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Quick Actions Label
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Quick Actions"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Grid Container
    private let gridStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupQuickActionsGrid()
    }
    
    private func setupUI() {
        title = "Hoogmatic Dashboard"
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerCardView)
        headerCardView.addSubview(nameLabel)
        headerCardView.addSubview(roleLabel)
        headerCardView.addSubview(walletTitleLabel)
        headerCardView.addSubview(walletAmountLabel)
        
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(gridStackView)
        
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
            
            headerCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: headerCardView.topAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: headerCardView.leadingAnchor, constant: 18),
            
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            roleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            walletTitleLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            walletTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            walletAmountLabel.topAnchor.constraint(equalTo: walletTitleLabel.bottomAnchor, constant: 2),
            walletAmountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            walletAmountLabel.bottomAnchor.constraint(equalTo: headerCardView.bottomAnchor, constant: -18),
            
            sectionTitleLabel.topAnchor.constraint(equalTo: headerCardView.bottomAnchor, constant: 20),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            gridStackView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 12),
            gridStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gridStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gridStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupQuickActionsGrid() {
        let row1 = createRowStackView(
            card1: createActionCard(title: "Insurance Panel", subtitle: "SSO & Verification", iconName: "shield.checkerboard", color: UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0), action: #selector(didTapInsurance)),
            card2: createActionCard(title: "Services", subtitle: "Recharge & Utilities", iconName: "grid.fill", color: UIColor(red: 0.09, green: 0.64, blue: 0.72, alpha: 1.0), action: #selector(didTapServices))
        )
        
        let row2 = createRowStackView(
            card1: createActionCard(title: "Money Transfer", subtitle: "Instant Payouts", iconName: "arrow.triangle.2.circlepath", color: UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.0), action: #selector(didTapServices)),
            card2: createActionCard(title: "My Orders", subtitle: "Transaction History", iconName: "doc.text.fill", color: UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0), action: #selector(didTapServices))
        )
        
        gridStackView.addArrangedSubview(row1)
        gridStackView.addArrangedSubview(row2)
    }
    
    private func createRowStackView(card1: UIView, card2: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [card1, card2])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }
    
    private func createActionCard(title: String, subtitle: String, iconName: String, color: UIColor, action: Selector) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.layer.shadowOpacity = 0.08
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let tLabel = UILabel()
        tLabel.text = title
        tLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        tLabel.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subLabel = UILabel()
        subLabel.text = subtitle
        subLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        subLabel.textColor = UIColor(red: 0.47, green: 0.56, blue: 0.61, alpha: 1.0)
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconView)
        card.addSubview(tLabel)
        card.addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 110),
            
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            tLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
            tLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            tLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
            
            subLabel.topAnchor.constraint(equalTo: tLabel.bottomAnchor, constant: 2),
            subLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            subLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: action)
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true
        
        return card
    }
    
    @objc private func didTapInsurance() {
        let vc = InsurancePanelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapServices() {
        if let url = URL(string: "https://connector.hoogmatic.in/index.php?path=home") {
            let webVC = WebActionViewController(url: url, title: "Hoogmatic Services")
            let nav = UINavigationController(rootViewController: webVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
}
