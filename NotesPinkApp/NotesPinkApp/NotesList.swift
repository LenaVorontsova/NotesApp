import CoreData

@objc(List)
class List: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var titleText: String!
    @NSManaged var detailsText: String!
    @NSManaged var deletedDate: Date?
}
