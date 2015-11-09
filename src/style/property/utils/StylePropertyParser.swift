import Cocoa

class StylePropertyParser{
    /**
     * Returns a property from @param skin and @param property
     * @Note the reason that depth defaults to 0 is because if the exact depth isnt found there should only be depth 0, if you have more than 1 depth in a property then you must supply at all depths or just the 1 that will work for all depths
     * // :TODO: should probably also support when state is know and depth is defaulted to 0 ?!?!?
     */
    class func value(skin:ISkin, _ propertyName:String/*, depth:int = 0*/)->Any{
        let value:Any = skin.style!.getValue(propertyName);
        return value;
    }
    class func fillStyle(skin:ISkin)->IFillStyle {
        return value(skin,CSSConstants.fill) is IGradient ? gradientFillStyle(skin):colorFillStyle(skin);
    }
    /**
    * Returns a FillStyle instance
    */
    class func colorFillStyle(skin:ISkin)->IFillStyle {
        let value:String = StylePropertyParser.value(skin, CSSConstants.fill) as! String;
        //print("value: " + value);
        let alpha:String = StylePropertyParser.value(skin, CSSConstants.fillAlpha) as! String;
        let color:NSColor = value == CSSConstants.none ? NSColor.clearColor() : ColorParser.nsColor(value, Float(alpha)!)//fill
        
        return FillStyle(color)
    }
    /**
    * Returns a GradientFillStyle
    */
    class func gradientFillStyle(skin:ISkin) -> GradientFillStyle {
        fatalError("NOT IMPLEMENTED YET")
    }
    /**
     *
     */
    class func width(skin:ISkin) -> Int {
        return metric(skin,CSSConstants.WIDTH,depth);
    }
    /**
    * Returns a Number derived from eigther a percentage value or ems value (20% or 1.125 ems == 18)
    */
    class func metric(skin:ISkin,propertyName:String,depth:int):Number {
        var value:* = StylePropertyParser.value(skin,propertyName,depth);
        return Utils.metric(value,skin);
    }
}