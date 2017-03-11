import Cocoa
@testable import Utils

//Continue here: 
    //get dierect transmission again

class DEPRECATEDRBScrollView:ScrollView, DEPRECATEDIRBScrollable {
    /*RubberBand*/
    var mover:RubberBand?
    var prevScrollingDeltaY:CGFloat = 0/*this is needed in order to figure out which direction the scrollWheel is going in*/
    var velocities:[CGFloat] = Array(repeating: 0, count: 10)/*represents the velocity resolution of the gesture movment*/
    var progressValue:CGFloat?//<--same as progress but unclamped (because RBSliderList may go beyond 0 to 1 values etc)
    override func resolveSkin() {
        super.resolveSkin()
        /*RubberBand*/
        let frame = CGRect(0,0,width,height)/*represents the visible part of the content *///TODO: could be ranmed to maskRect
        let itemsRect = CGRect(0,0,width,itemsHeight)/*represents the total size of the content *///TODO: could be ranmed to contentRect
        mover = RubberBand(Animation.sharedInstance,setProgress,frame,itemsRect)
        mover!.event = onEvent/*Add an eventHandler for the mover object, avoids logging missing eventHandler, this has no functionality in this class, but may have in classes that extends this class*/
    }
    /**
     * NOTE: this method overides the Native NSView scrollWheel method
     */
    override func scrollWheel(with event:NSEvent) {
        //Swift.print("RBScrollView.scrollWheel")
        (self as DEPRECATEDIRBScrollable).scroll(event)//forward the event to the scrollExtension
        if(event.phase == NSEventPhase.changed){setProgress(mover!.result)}/*direct manipulation*/
        //IMPORTANT: for now let's not pass on the scrollWheel.if this backfires, aka wee need scroolwheel for NSView at another level, then make a scheme that calls the correct scroll, aka make scroll inheritable and overridable and then call doScroll with the extension method attached
        //super.scrollWheel(with: event)/*keep forwarding the scrollWheel event for NSViews higher up the hierarcy to listen to*/
    }
}
extension DEPRECATEDRBScrollView {
    /**
     * PARAM value: is the final y value for the lableContainer
     * TODO: Try to use a preCalculated itemsHeight, as this can be heavy to calculate for lengthy lists
     */
    /*func setProgress(_ value:CGFloat){
     //Swift.print("RBScrollView.setProgress() value: " + "\(value)")
     lableContainer!.frame.y = value/*<--this is where we actully move the labelContainer*/
     progressValue = value / -(itemsHeight - height)/*get the the scalar values from value.*/
     }*/
}
