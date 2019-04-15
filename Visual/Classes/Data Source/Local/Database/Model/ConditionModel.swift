

import RealmSwift

public class ConditionModel: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var cId: Int = 0
    @objc dynamic var standard: String = ""
    @objc dynamic var funcType: String = ""
    @objc dynamic var funcKeys: String = ""
   
    
    override public class func primaryKey() -> String? {
        return "id"
    }
     
    func toCondition() -> Condition  {
    
        return Condition((id: self.id,
                          cId: self.cId,
                          standard: self.standard,
                          funcType: self.funcType,
                          funcKeys: self.funcKeys
                          ))
        
    }
}
