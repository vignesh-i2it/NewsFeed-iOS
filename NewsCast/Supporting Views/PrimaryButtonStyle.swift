//
//  PrimaryButtonStyle.swift
//  NewsCast
//
//  Created by Vignesh on 11/05/23.
//

import SwiftUI

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}


struct PrimaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled

    
    func makeBody(configuration: Configuration) -> some View {
        Group {
                    if isEnabled {
                        configuration.label
                    } else {
                        ProgressView()
                    }
                }
            .font(.title3)
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(.blue)
            .cornerRadius(50)
            .padding()
            .animation(.default, value: isEnabled)
//            .padding()
//            .frame(maxWidth: .infinity)
//            .foregroundColor(.white)
//            .background(Color.accentColor)
//            .cornerRadius(10)
    }
}


//struct PrimaryButtonStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        PrimaryButtonStyle()
//    }
//}
