func generateMadLib(adjective1: String, noun1: String, verbPastTense: String, adjective2: String, noun2: String, verb: String, noun3: String, adjective3: String) -> String {
    
    if adjective1.isEmpty || noun1.isEmpty || verbPastTense.isEmpty || adjective2.isEmpty || noun2.isEmpty || verb.isEmpty || noun3.isEmpty || adjective3.isEmpty {
        return "Invalid Input"
    }
    
    let randomStorySelection = Int.random(in: 1...3)
    
    switch randomStorySelection {
    case 1:
        return """
    On a \(adjective1) Halloween night, a group of friends decided to visit the old \(noun1). They \(verbPastTense) through the dark forest, feeling very \(adjective2). Suddenly, they heard a noise coming from the \(noun2). They decided to \(verb) closer to investigate. To their surprise, they found a \(noun3) that was glowing \(adjective3) in the moonlight. It was the spookest Halloween night they had ever experienced!
    """
    case 2:
        return """
            The \(noun1) looked \(adjective1) as the wind \(verbPastTense) through the trees. Everyone felt \(adjective2) and rna toward the \(noun2). Suddenly, a \(noun3) appeared and started to \(verb) \(adjective3) in the yard. It was a Halloween night they would never forget!
            """
    case 3:
        return """
            On the \(adjective1) evening, the \(noun1) was quiet. They \(verbPastTense) past the \(noun2), feeling \(adjective2). A mysterious \(noun3) began to \(verb) in a \(adjective3) light. That Halloween became the most memoralbe one ever!
            """
    default:
        return "Invalid Input"
    }
}
    
var madLibStory = generateMadLib(adjective1: "Slimy", noun1: "Coffeeville", verbPastTense: "Remember", adjective2: "Cold", noun2: "Carl", verb: "Sneak", noun3: "Doll", adjective3: "Frightful")
print(madLibStory)

madLibStory = generateMadLib(adjective1: "cold", noun1: "car", verbPastTense: "ran", adjective2: "hot", noun2: "house", verb: "shake", noun3: "president", adjective3: "famous")
print(madLibStory)

madLibStory = generateMadLib(adjective1: "comforting", noun1: "", verbPastTense: "late", adjective2: "high", noun2: "", verb: "spin", noun3: "", adjective3: "vast")
print(madLibStory)
