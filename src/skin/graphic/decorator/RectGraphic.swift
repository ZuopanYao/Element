import Foundation

class RectGraphic:GraphicDecoratable{
    var width:Double;
    var height:Double;
    init(_ decoratable: IGraphicDecoratable, _ width:Double = 100, _ height:Double = 100) {
        
        super.init(decoratable)
    }
    override func drawFill() {
        getGraphic().path = CGPathParser.rect(CGFloat(width), CGFloat(height))
    }
    func setSize(width:Double,height:Double) {
        self.width = width;
        self.height = height;
    }
}
