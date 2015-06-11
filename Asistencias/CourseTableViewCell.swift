//
//  CourseTableViewCell.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    var course: Course!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
