import Cocoa
@testable import Utils
/**
 * NOTE: the slider keeps track of the progress
 * TODO: you may need to add an update method like SliderTreeList has, imagine if your scrolled to the bottom nd then an item is removed what happens? you should update the slider and y.position of the itemsContainer
 * TODO: Do more research into the scroller speed. as its now an  arbetrary value of 30. Do you pull this from the user profile or?
 */
class SliderList:List,ISliderList{
    var slider:VSlider?
    var sliderInterval:CGFloat?
    override func resolveSkin() {
        super.resolveSkin()
        //TODO:It could be possible to remove the bellow code and just call updateSlider as it contains almost the same code
        sliderInterval = floor(ListParser.itemsHeight(self) - height)/itemHeight// :TODO: use ScrollBarUtils.interval instead?// :TODO: explain what this is in a comment
        slider = addSubView(VSlider(itemHeight,height,0,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/itemsHeight, slider!.height)
        slider!.setThumbHeightValue(thumbHeight)//<--TODO: Rather set the thumbHeight on init?
        //ElementModifier.hide(slider!, ListParser.itemsHeight(self) > slider!.height)/*<--new adition*/
    }
    override func scrollWheel(with event: NSEvent) {//swift 3 update
        scroll(event)/*forward the event to the extension*/
        Swift.print("firstVisibleItem: " + "\(firstVisibleItem)")
        super.scrollWheel(with: event)/*forward the event other delegates higher up in the stack*/
    }
    func setProgress(_ progress:CGFloat){
        let progressValue = self.itemsHeight < height ? 0 : progress/*pins the lableContainer to the top if itemsHeight is less than height*/
        //Swift.print("progressValue: " + "\(progressValue)")
        ListModifier.scrollTo(self,progressValue)/*Sets the target item to correct y, according to the current scrollBar progress*/
    }
    func onSliderChange(_ sliderEvent:SliderEvent){/*Handler for the SliderEvent.change*/
        setProgress(sliderEvent.progress)
    }
    /**
     * TODO: Add hide slider asssert here see SliderList for implementation
     */
    override func onDataProviderEvent(_ event:DataProviderEvent) {
        super.onDataProviderEvent(event)
        Swift.print("event.startIndex: " + "\(event.startIndex)")
        Swift.print("firstVisibleItem: " + "\(firstVisibleItem)")
        alignLableContainer(event)
        updateSlider()
    }
    override func onEvent(_ event:Event) {
        if(event.assert(SliderEvent.change, slider)){onSliderChange(event.cast())}/*events from the slider*/
        super.onEvent(event)
    }
    /**
     * TODO: must update the float somehow
     * Sets the list to correct height, the scrollbar thumb to correct size and the scrollbar interval to correct interval
     */
    override func setSize(_ width:CGFloat, _ height:CGFloat) {//TODO: when max showing is set to 3 and there are 4 items the sliderTHumbsize is wrong
        slider!.setSize(itemHeight, height)
        sliderInterval = floor(ListParser.itemsHeight(self) - height)/itemHeight
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/itemsHeight, slider!.height/*<--this should probably be .getHeight()*/);
        slider!.setThumbHeightValue(thumbHeight)
        super.setSize(width,height)
        ElementModifier.hide(slider!, itemsHeight > slider!.height)/*Hides the slider if it is not needed anymore*///<--new adition
    }
}
extension IList{
    /**
     * Returns the first item that visible within view. (item.bottom must cross top of view to count as visible)
     */
    var firstVisibleItem:Int{
        let a = abs(lableContainer!.y)//force positive value with abs
        let b = a/itemHeight//how many items fit into "a"
        let c = floor(b)//Continue here
        let firstVisibleItem:Int = c.int
        //Swift.print("firstVisibleItem: " + "\(firstVisibleItem)")
        return firstVisibleItem
    }
    /**
     * Returns the last item that is visible within view (item top has not crossed bottom of view)
     * NOTE: the existens of item at this index is not garantued. Its the virtual idx of such an item
     */
    var lastVisibleItem:Int{
        let a:Int = firstVisibleItem
        let b = height/itemHeight
        //Swift.print("b: " + "\(b)")
        let c = ceil(b)
        //Swift.print("c: " + "\(c)")
        let d = c == 0 ? 0 : c + 1//add an extra item to cover the area. should be dealt with in the render method really
        //Swift.print("d: " + "\(d)")
        let lastVisibleItem:Int = a + d.int
        //Swift.print("lastVisibleItem: " + "\(lastVisibleItem)")
        return lastVisibleItem
    }
    
    /**
     * Returns number of items that can fit height
     */
    var numOfItemsThatCanFit:Int {
        return floor(height/itemHeight).int
    }
    /**
     * Alignes the lableContainer after its content has been changed (add/remove of item)
     */
    func alignLableContainer(_ event:DataProviderEvent){
        /*Pin to top if itemsHeight is less than height*/
        if(itemsHeight < height){//basically when itemsHeight is less than height was /*dp.count <= numOfItemsThatCanFit*/
            lableContainer!.y = 0
        }
        /*Pin to bottom if (lableContainer.y + itemsHeight) is less than (height) and itemsHeight is more than height*/
        else if(itemsHeight > height){
            if((lableContainer!.y + itemsHeight) < height){
                lableContainer!.y = -(itemsHeight - height)
            }
        }
        /*If an item is added / removed above the first visible item*/
        else if(event.startIndex < firstVisibleItem){
            if(event.type == DataProviderEvent.remove){
                lableContainer!.y += itemHeight
                Swift.print("offset.y + 24")
            }else if(event.type == DataProviderEvent.add){
                lableContainer!.y -= itemHeight
                Swift.print("offset.y - 24")
            }
        }
    }
}