

import RealmSwift

public class AdvertisementModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var label = ""
    @objc dynamic var content = ""
    @objc dynamic var linkTo = ""
    @objc dynamic var linkToType = ""
    @objc dynamic var linkToStr = ""
    @objc dynamic var image = ""
    @objc dynamic var iconImage = ""
    @objc dynamic var priority = 0
    @objc dynamic var query = ""
    
    override public class func primaryKey() -> String? {
        return "id"
    }
     
    func toAdvertisment() -> Advertisement  {
    
        return Advertisement((id: self.id, title: self.title, label: self.label,
                              content: self.content, linkTo: self.linkTo, linkToType: self.linkToType,
                              linkToStr: self.linkToStr, image: self.image, iconImage: self.iconImage,
                              priority: self.priority, query: self.query))
        
    }
}
