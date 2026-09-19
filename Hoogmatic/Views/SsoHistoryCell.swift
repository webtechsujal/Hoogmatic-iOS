import UIKit

public class SsoHistoryCell: UITableViewCell {
    public static let identifier = "SsoHistoryCell"
    
    public var onViewTapped: (() -> Void)?
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.08
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mobileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.27, green: 0.35, blue: 0.39, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.27, green: 0.35, blue: 0.39, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.47, green: 0.56, blue: 0.61, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.09, green: 0.64, blue: 0.72, alpha: 1.0) // #17A2B8
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(nameLabel)
        cardContainerView.addSubview(mobileLabel)
        cardContainerView.addSubview(emailLabel)
        cardContainerView.addSubview(timeLabel)
        cardContainerView.addSubview(viewButton)
        
        viewButton.addTarget(self, action: #selector(didTapView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            viewButton.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -14),
            viewButton.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            viewButton.widthAnchor.constraint(equalToConstant: 72),
            viewButton.heightAnchor.constraint(equalToConstant: 34),
            
            nameLabel.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 14),
            nameLabel.trailingAnchor.constraint(equalTo: viewButton.leadingAnchor, constant: -10),
            
            mobileLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            mobileLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            mobileLabel.trailingAnchor.constraint(equalTo: viewButton.leadingAnchor, constant: -10),
            
            emailLabel.topAnchor.constraint(equalTo: mobileLabel.bottomAnchor, constant: 2),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: viewButton.leadingAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: viewButton.leadingAnchor, constant: -10),
            timeLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -14)
        ])
    }
    
    @objc private func didTapView() {
        onViewTapped?()
    }
    
    public func configure(with item: SsoHistoryItem, index: Int) {
        nameLabel.text = "\(index + 1). \(item.displayName)"
        mobileLabel.text = "Mobile: \(item.customerMobile ?? "N/A")"
        emailLabel.text = "Email: \(item.customerEmail ?? "N/A")"
        timeLabel.text = "Date: \(item.displayTime)"
    }
}
