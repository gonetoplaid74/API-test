extension InteractionCategory {
    static let ball = InteractionCategory(rawValue: 1 << 0)
    static let paddle = InteractionCategory(rawValue: 1 << 1)
    static let brick = InteractionCategory(rawValue: 1 << 2)
    static let wall = InteractionCategory(rawValue: 1 << 3)
    static let foulLine = InteractionCategory(rawValue: 1 << 4)
    static let knob = InteractionCategory(rawValue: 1 << 5)
    static let inactive = InteractionCategory(rawValue: 1 << 6)
    static let oddBrick = InteractionCategory(rawValue: 1 << 7)
    static let oddBall = InteractionCategory(rawValue: 1 << 8)
}
