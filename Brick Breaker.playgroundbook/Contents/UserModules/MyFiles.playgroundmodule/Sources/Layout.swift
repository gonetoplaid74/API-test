/// /*#-localizable-zone(usermodule17)*/An array of colors used to set up the bricks in a Brick Breaker level./*#-end-localizable-zone*/ 
public struct Layout {
    
    /// /*#-localizable-zone(usermodule18)*/The colors of the layout, arranged in an array./*#-end-localizable-zone*/
    public var colors: [[Color]] = []
    
    /// /*#-localizable-zone(usermodule19)*/The default number of rows in a layout./*#-end-localizable-zone*/
    public static var defaultRows = 4
    
    /// /*#-localizable-zone(usermodule20)*/The default number of columns in a layout./*#-end-localizable-zone*/
    public static var defaultColumns = 4
    
    /// /*#-localizable-zone(usermodule21)*/The number of rows in the layout./*#-end-localizable-zone*/
    public var rows: Int {
        return colors.count
    }
    
    /// /*#-localizable-zone(usermodule22)*/The number of columns in the layout./*#-end-localizable-zone*/
    public var columns: Int {
        guard let firstRow = colors.first else { return 0 }
        return firstRow.count
    }
    
    /// /*#-localizable-zone(usermodule23)*/A custom layout constructed with color literals./*#-end-localizable-zone*/
    public static var custom: Layout {
        let layoutColors: [[Color]] = [
            [#colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0)],
            [#colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0)],
            [#colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0)],
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 0.9098039215686274, green: 0.47843137254901963, blue: 0.6431372549019608, alpha: 1.0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)],
            [#colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0)],
            [#colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0)],
            [#colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0)]
        ]
        return Layout(colors: layoutColors)
    }
    
    /// /*#-localizable-zone(usermodule24)*/Creates a layout using an array of colors./*#-end-localizable-zone*/
    public init(colors: [[Color]]) {
        self.colors = colors
    }
    
    /// /*#-localizable-zone(usermodule25)*/Creates a plain layout of a default color./*#-end-localizable-zone*/
    public static func plain(rows: Int = defaultRows, columns: Int = defaultColumns) -> Layout {
        return Layout.color(.cyan, rows: rows, columns: columns)
    }
    
    /// /*#-localizable-zone(usermodule26)*/Creates a layout of a specific color./*#-end-localizable-zone*/
    public static func color(_ color: Color, rows: Int = defaultRows, columns: Int = defaultColumns) -> Layout {
        let row = Array(repeating: color, count: columns)
        return Layout(colors: Array(repeating: row, count: rows))
    }
    
    /// /*#-localizable-zone(usermodule27)*/Creates a layout of random colors./*#-end-localizable-zone*/
    public static func random(colors: [Color], rows: Int = defaultRows, columns: Int = defaultColumns) -> Layout {
        var layoutColors: [[Color]] = []
        for _ in 0..<rows {
            var rowColors: [Color] = []
            for _ in 0..<columns {
                rowColors.append(colors.randomElement() ?? .clear)
            }
            layoutColors.append(rowColors)
        }
        return Layout(colors: layoutColors)
    }
}
