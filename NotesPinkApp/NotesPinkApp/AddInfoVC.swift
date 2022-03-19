import UIKit
import CoreData
import Foundation

class AddInfoVC: UIViewController {
    
    var selectedNote: List? = nil

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedNote != nil {
            titleTF.text = selectedNote?.titleText
            descriptionTV.text = selectedNote?.detailsText
        }
    }

    @IBAction func saveInfo(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if selectedNote == nil {
            let entity = NSEntityDescription.entity(forEntityName: "List", in: context)
            let newList = List(entity: entity!, insertInto: context)
            newList.titleText = titleTF.text
            newList.detailsText = descriptionTV.text
            newList.id = notesList.count as NSNumber
            do {
                try context.save()
                notesList.append(newList)
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("Context save error")
            }
        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let list = result as! List
                    if list == selectedNote {
                        list.titleText = titleTF.text
                        list.detailsText = descriptionTV.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch  {
                print("Fetch Failed")
            }
        }
    }
    
    @IBAction func deleteInfo(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let list = result as! List
                if list == selectedNote {
                    list.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch  {
            print("Fetch Failed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

