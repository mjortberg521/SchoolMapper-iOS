//  Copyright © 2018 Matthew Jortberg. All rights reserved.

import UIKit
import MapKit

class AnnotationView: MKAnnotationView {
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let Annotation = self.annotation as? Annotations else { return }
        
        image = Annotation.type.image()
    }
}
