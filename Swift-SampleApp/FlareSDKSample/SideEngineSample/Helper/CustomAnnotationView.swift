//
//  CustomAnnotationView.swift
//  FlareSDKSample
//
//  Created by Phoenix Innovate on 24/09/24.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageView()
    }

    private func setupImageView() {
        // Set the content mode to aspect fit
        imageView.contentMode = .scaleAspectFit
        
        // Add imageView as subview to the annotation view
        addSubview(imageView)
        
        // Make sure imageView fits the annotation view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // This will set the image and automatically scale it to fit the frame while keeping the aspect ratio
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}

