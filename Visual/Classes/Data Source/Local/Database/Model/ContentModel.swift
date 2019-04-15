

import RealmSwift

public class ContentModel: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var priority: Int = 0
    @objc dynamic var categoryPriority: Int = 0
    @objc dynamic var numOfOccurrence: Int = 0
    @objc dynamic var lCode: Int = 0
    @objc dynamic var rawKeys: String = ""
    @objc dynamic var linkTo: String = ""
    @objc dynamic var label: String = ""
    @objc dynamic var largeContent: String = ""
    @objc dynamic var largeKeys: String = ""
    @objc dynamic var mediumContent: String = ""
    @objc dynamic var mediumKeys: String = ""
    @objc dynamic var image: String = ""

    override public class func primaryKey() -> String? {
        return "id"
    }
     
    func toContent() -> Content  {
    
        return Content((id: self.id,
                        priority: self.priority,
                        categoryPriority: self.categoryPriority,
                        numOfOccurrence: self.numOfOccurrence,
                        lCode: self.lCode,
                        rawKeys: self.rawKeys,
                        linkTo: self.linkTo,
                        label: self.label,
                        largeContent: self.largeContent,
                        largeKeys: self.largeKeys,
                        mediumContent: self.mediumContent,
                        mediumKeys: self.mediumKeys,
                        image: self.image))
        
    }
}
