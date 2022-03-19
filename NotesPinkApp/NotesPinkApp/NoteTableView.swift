import Foundation
import UIKit
import CoreData

var notesList = [List]()

class NoteTableView: UITableViewController {

    var firstLoad = true
    
    func nonDeletedList() -> [List] {
        var noDeletedNotesList = [List]()
        for note in notesList {
            if note.deletedDate == nil {
                noDeletedNotesList.append(note)
            }
        }
        return noDeletedNotesList
    }
    
    override func viewDidLoad() {
        if firstLoad {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteInfo")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let list = result as! List
                    notesList.append(list)
                }
            }
            catch  {
                print("Fetch Failed")
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "ListCellID", for: indexPath) as! NoteCell
        
        let thisList: List!
        thisList = nonDeletedList()[indexPath.row]
        listCell.titleLabel.text = thisList.titleText
        listCell.descriptionLabel.text = thisList.detailsText
        
        return listCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedList().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let indexPath = tableView.indexPathForSelectedRow!
            let listDetail = segue.destination as? AddInfoVC
             
            let selectedList: List!
            selectedList = nonDeletedList()[indexPath.row]
            listDetail!.selectedNote = selectedList
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
