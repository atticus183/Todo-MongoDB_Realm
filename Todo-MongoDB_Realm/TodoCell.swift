//
//  TodoCell.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import Foundation
import UIKit

class TodoCell: UITableViewCell {

    // The cell's reuseIdentifier
    static var identifier: String {
        String(describing: Self.self)
    }

    var todo: Todo? {
        didSet {
            guard let todo = todo else { return }
            let todoText = NSAttributedString(string: todo.title,
                                          attributes: todo.isCompleted
                                            ? [.strikethroughStyle: true,
                                               .foregroundColor: UIColor.gray]
                                            : [:])
            textLabel?.attributedText = todoText
            detailTextLabel?.textColor = .gray
            detailTextLabel?.text = todo.dateCreatedFormatted
        }
    }

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
