import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoKeyPathCodingMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard
            let structDecl = declaration.as(StructDeclSyntax.self),
            let codingKeysEnum = structDecl.memberBlock.members
                .compactMap({ $0.decl.as(EnumDeclSyntax.self) })
                .first(where: { $0.name.text == "CodingKeys" })
        else {
            return []
        }

        var mapCases: [String] = []

        for member in codingKeysEnum.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }

            for elem in caseDecl.elements {
                let propName = elem.identifier.text
                let serverName = elem.rawValue?.value.description
                    .replacing("\"", with: "")
//                    .replacingOccurrences(of: "\"", with: "")
                    ?? propName

                let line =
                """
                \\Self.\(propName): "\(serverName)"
                """

                mapCases.append(line)
            }
        }

        let mapBody = mapCases.joined(separator: ",\n")

        return [
            """
            static var keyPathCodingMap: [PartialKeyPath<Self>: String] {
                return [
                    \(raw: mapBody)
                ]
            }
            """
        ]
    }
}
