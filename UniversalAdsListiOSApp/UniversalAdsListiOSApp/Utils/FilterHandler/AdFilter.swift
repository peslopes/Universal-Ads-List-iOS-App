struct AdFilter: Hashable {
    let id: String
    let filter: (AdModel) -> Bool
    
    static func == (lhs: AdFilter, rhs: AdFilter) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
