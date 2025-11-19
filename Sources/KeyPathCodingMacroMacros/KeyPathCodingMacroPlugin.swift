//
//  KeyPathCodingMacroPlugin.swift
//  KeyPathCodingMacro
//
//  Created by Moha on 11/19/25.
//


import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KeyPathCodingMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoKeyPathCodingMacro.self
    ]
}
