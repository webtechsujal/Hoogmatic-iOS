import Foundation

public struct SsoHistoryResponse: Codable {
    public let status: String
    public let userId: Int?
    public let data: [SsoHistoryItem]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case userId = "user_id"
        case data
    }
}

public struct SsoHistoryItem: Codable {
    public let id: Int?
    public let userId: Int?
    public let customerName: String?
    public let fullName: String?
    public let customerEmail: String?
    public let customerMobile: String?
    public let status: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let loggedInAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case customerName = "customer_name"
        case fullName = "full_name"
        case customerEmail = "customer_email"
        case customerMobile = "customer_mobile"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case loggedInAt = "logged_in_at"
    }
    
    public var displayName: String {
        if let name = customerName, !name.isEmpty {
            return name
        }
        if let fn = fullName, !fn.isEmpty {
            return fn
        }
        return "Customer"
    }
    
    var displayTime: String {
        if let time = loggedInAt, !time.isEmpty {
            return time
        }
        if let ca = createdAt, !ca.isEmpty {
            return ca
        }
        return ""
    }
}
