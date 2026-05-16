import Foundation

struct Choice: Codable, Identifiable {
    let id: String
    let label: String
    let category: ChoiceCategory
    let sortOrder: Int

    enum CodingKeys: String, CodingKey {
        case id
        case label
        case category
        case sortOrder = "sort_order"
    }
}

enum ChoiceCategory: String, Codable {
    case greet
    case feel
    case action
    case end
}
