import Foundation
/**
 * HorizontalNodeSlider is used when 2 sliders are need, as in section definition or zoom, or gradient values
 */
class HNodeSlider:Element {
    var startNode:SelectButton?
    var endNode:SelectButton?
    var selectGroup:SelectGroup?
    var nodeWidth:CGFloat
    var tempNodeMouseX:CGFloat?
    var startProgress:CGFloat
    var endProgress:CGFloat
    init(width:CGFloat = NaN, height:CGFloat = NaN, nodeWidth:CGFloat = NaN, startProgress:CGFloat = 0, endProgress:CGFloat = 1, parent:IElement? = nil, id:String? = nil, classId:String? = nil) {
        self.startProgress = startProgress
        self.endProgress = endProgress
        self.nodeWidth = nodeWidth.isNaN ? height:nodeWidth
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin();
        startNode = addSubView(SelectButton(nodeWidth, height, false, self, "start"))
        setStartProgress(startProgress)
        endNode = addSubView(SelectButton(nodeWidth, height, false, self, "end"))
        setEndProgress(endProgress)
        selectGroup = SelectGroup([startNode,endNode])
        selectGroup.setSelected(startNode)
    }
    func onStartNodeDown(event : ButtonEvent) {
//		DepthModifier.toFront(_startNode, this);
        tempNodeMouseX = startNode.mouseX;
        //add on move handler here
    }
    func onEndNodeDown(event : ButtonEvent) {
//		DepthModifier.toFront(_endNode, this);
        tempNodeMouseX = endNode.mouseX;
        //add on move handler here
    }
    func onStartNodeMove(event : MouseEvent) {
        _startProgress = Utils.progress(this.mouseX, _tempNodeMouseX, width, _nodeWidth);
        _startNode.x = Utils.nodePosition(_startProgress, width, _nodeWidth);
        dispatchEvent(new NodeSliderEvent(NodeSliderEvent.CHANGE,_startProgress,_endProgress,_startNode));
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}