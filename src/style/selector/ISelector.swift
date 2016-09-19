protocol ISelector{
    var element:String{get}
    var classIds:Array<String>{get}
    var id:String{get}
    var states:Array<String>{get}
}
extension ISelector{
    /**
     * Converts xml to a Selector
     */
    static func selector(xml:XML)->ISelector{
        //Swift.print("xml.string: " + "\(xml.string)")
        let element:String = xml.firstNode("element")!.value
        //Swift.print("element: " + "\(element)")
        let id:String = xml.firstNode("id")!.value
        //Swift.print("id: " + "\(id)")
        let classIds:[String] = xml.firstNode("classIds")!.children?.flatMap{
            ($0 as! XML).value
        } ?? []//<--or empty array
        //Swift.print("classIds.count: " + "\(classIds.count)")
        let states:[String] = xml.firstNode("states")!.children?.flatMap{
            ($0 as! XML).value
        } ?? []//<--or empty array
        //Swift.print("states.count: " + "\(states.count)")
        return Selector(element,classIds,id,states)
    }
}