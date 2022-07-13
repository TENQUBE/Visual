

import RealmSwift

public class AnalysisModel: Object {

    @objc dynamic var id: Int = 0
    @objc dynamic var categoryPriority: Int = 0
    @objc dynamic var image: String = ""
    @objc dynamic var label: String = ""
    @objc dynamic var lContent: String = ""
    @objc dynamic var mContent: String = ""
    @objc dynamic var tranIds: String = ""
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toAnalysis() -> AnalysisResult {
        
        return AnalysisResult((id: self.id,
                         categoryPriority: self.categoryPriority,
                         image: self.image,
                         label: self.label,
                         lContent: self.lContent,
                         mContent: self.mContent,
                         tranIds: self.tranIds.components(separatedBy: ",").map{ Int($0)!}
        ))
        
    }
    
    
}
