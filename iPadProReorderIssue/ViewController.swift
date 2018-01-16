//
//  ViewController.swift
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerLabel.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.headerLabel.text = nil
    }
    
    func configure(headerText: String) {
        self.headerLabel.text = headerText
    }
}

protocol ReuseIdentifierCell {
    
    static var nib: UINib { get }
    
    static var reuseIdentifier: String { get }
}


extension ReuseIdentifierCell {
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifierCell {
}

class ListSection<ListItem> {
    
    var items: [ListItem]
    var headerTitle: String?
    var footerTitle: String?
    
    required init(items: [ListItem], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
}

class ProfileSettingListCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Lets' show white background for selected cells, we only want to show checkmark.
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.selectedBackgroundView = view
        
        self.checkbox.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor).isActive = true
    }
    
    var isChecked: Bool = false {
        didSet {
            self.checkbox.isSelected = self.isChecked
        }
    }
    
    func configure(title: String)  {
        self.title?.text = title
    }
}

struct SettingsItem {
    var id: String
    var title: String
    var enabled: Bool
}

typealias ProfileListSection = ListSection<SettingsItem>

extension UITableViewHeaderFooterView: ReuseIdentifierCell {
}

extension UITableView {
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        self.register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
    
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
extension UIView {
    
    class func findShadowImage(under view: UIView?) -> UIImageView? {
        guard let view = view else {
            return nil
        }
        
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
}

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.registerHeaderFooterView(SettingsHeaderView.self)
            self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
    private var sections = [ProfileListSection]()
    // we have to keep track ourself of selection/enable state because
    // we use the Single Selection state in Editing mode to hide the right multiselection icons.
    // Single selections gives us at least didSelectRowAt
    private var enabledSectionSets = [IndexSet]()

    func removeSinglePixelLine() {
        UIView.findShadowImage(under: self.navigationController?.navigationBar)?.isHidden = true
        UIView.findShadowImage(under: self.tabBarController?.tabBar)?.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeSinglePixelLine()
        self.updateData(sections: [
            ProfileListSection(items: [
                SettingsItem(id: "1", title: "World News", enabled: true),
                SettingsItem(id: "2", title: "USWire", enabled: true),
                SettingsItem(id: "3", title: "Business News", enabled: true),
                SettingsItem(id: "4", title: "Technology", enabled: true),
                SettingsItem(id: "5", title: "Politics", enabled: true),
                SettingsItem(id: "6", title: "Science", enabled: true),
                SettingsItem(id: "7", title: "North Korea", enabled: true),
                SettingsItem(id: "8", title: "Donald Trump", enabled: true),
                SettingsItem(id: "9", title: "Davos 2017", enabled: true),
                SettingsItem(id: "10", title: "Asia", enabled: false),
                SettingsItem(id: "11", title: "European Politics", enabled: false),
                SettingsItem(id: "12", title: "Change Climate", enabled: false),
                SettingsItem(id: "13", title: "Change Manufacturing", enabled: false),
                SettingsItem(id: "14", title: "AreoSpace & Defence", enabled: false),
                SettingsItem(id: "15", title: "Deals", enabled: false),
                SettingsItem(id: "16", title: "China", enabled: false),
                SettingsItem(id: "17", title: "Exchange-Traded Funds", enabled: false),
                SettingsItem(id: "18", title: "India", enabled: false),
                SettingsItem(id: "19", title: "Middle East and North Africa", enabled: false),
                SettingsItem(id: "20", title: "Euro Zone", enabled: false),
                SettingsItem(id: "21", title: "Supreme Court", enabled: false),
                SettingsItem(id: "22", title: "Autos", enabled: false),
                SettingsItem(id: "23", title: "Special Reports", enabled: false),
                SettingsItem(id: "24", title: "Science News", enabled: false),
                SettingsItem(id: "25", title: "Science News 2", enabled: false)
                ],
                               headerTitle: NSLocalizedString("TOPICS", comment: "")),
            ProfileListSection(items: [
                SettingsItem(id: "1", title: "Stocks", enabled: true),
                SettingsItem(id: "2", title: "Bonds", enabled: true),
                SettingsItem(id: "3", title: "Currencies", enabled: true),
                SettingsItem(id: "4", title: "Commodities", enabled: true)
                ],
                               headerTitle: NSLocalizedString("MARKETS", comment: ""))])
    }

    func updateData(sections: [ProfileListSection]) {
        self.sections = sections
        self.enabledSectionSets = []
        // Start editing before setting the selection, we need this because we want the
        // reorder (right drag icon) UI.
        self.tableView.setEditing(true, animated: false)
        for section in self.sections {
            var indexSet = IndexSet()
            // set the selectioncs
            for (index, setting) in section.items.enumerated() where setting.enabled {
                indexSet.insert(index)
            }
            self.enabledSectionSets.append(indexSet)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProfileSettingListCell
        cell.configure(title: item.title)
        cell.isChecked = self.enabledSectionSets[indexPath.section].contains(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.sections[sourceIndexPath.section].items[sourceIndexPath.row]
        
        // Update UI data
        self.sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
        self.sections[destinationIndexPath.section].items.insert(item, at: destinationIndexPath.row)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none // We want to hide the delete button on the left
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // We don't want the content indent because we layout the whole UI ourselves
        // with Autolayout in the Storyboards. Turning off "Indent While Editing" wasn't doing it.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerText = self.sections[section].headerTitle else {
            return nil
        }
        
        let header = self.tableView.dequeueReusableHeaderFooterView() as SettingsHeaderView
        header.configure(headerText: headerText)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56.0 // had to force headerheight for consistent heigt for both sections.
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // Make sure we can't drag and drop between 2 different sections:
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfileSettingListCell else { fatalError("Expected ProfileSettingListCell") }
        let enabled = self.enabledSectionSets[indexPath.section].contains(indexPath.row)
        
        if enabled {
            self.enabledSectionSets[indexPath.section].remove(indexPath.row)
        }
        else {
            self.enabledSectionSets[indexPath.section].insert(indexPath.row)
        }
        
        cell.isChecked = !enabled
    }
}
