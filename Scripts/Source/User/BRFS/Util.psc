Scriptname BRFS:Util Hidden Const

BRFS:NPC[] Function GetAllActors() global
    Keyword[] selector = new Keyword[1]
    selector[0] = Game.GetFormFromFile(0x90B1, "FalloutSlavery.esp") as Keyword
    Return GardenOfEden.FindActors(selector, None) as BRFS:NPC[]
EndFunction

BRFS:NPC Function GetActorByDisplayName(String name) global
    BRFS:NPC[] actors = GetAllActors()
    Int i = 0
    While i < actors.Length
        If actors[i].GetDisplayName() == name
            Return actors[i]
        EndIf
        i += 1
    EndWhile
EndFunction

Actor Function GetPlayerOrActorByDisplayName(String name) global
    If name == "player"
        Return Game.GetPlayer()
    EndIf
    Return GetActorByDisplayName(name)
EndFunction

ObjectReference[] Function DisplayNamesToRefArray(String arg, String sep=",") global
    ObjectReference[] result = new ObjectReference[0]

    String[] parts = System:Strings.Split(arg, sep)
    Int i = 0
    While i < parts.Length
        result.Add(GetPlayerOrActorByDisplayName(parts[i]))
        i += 1
    EndWhile

    Return result
EndFunction

Int[] Function StringToIntArray(String arg, String sep=",") global
    Int[] result = new Int[0]

    String[] parts = System:Strings.Split(arg, sep)
    Int i = 0
    While i < parts.Length
        result.Add(System:Int32.TryParse(parts[i], 10))
        i += 1
    EndWhile

    Return result
EndFunction

Form[] Function StringToFormArray(String arg, String sep=",") global
    Form[] result = new Form[0]

    String[] parts = System:Strings.Split(arg, sep)
    Int i = 0
    While i < parts.Length
        result.Add(Game.GetForm(System:Int32.TryParse(parts[i], 16)))
        i += 1
    EndWhile

    Return result
EndFunction

ObjectReference[] Function StringToRuntimeRefArray(String arg, String sep=",") global
    ObjectReference[] result = new ObjectReference[0]

    String[] parts = System:Strings.Split(arg, sep)
    Int i = 0
    While i < parts.Length
        result.Add(Game.GetForm(Math.LogicalOr(System:Int32.TryParse(parts[i], 16), 0xFF000000)) as ObjectReference)
        i += 1
    EndWhile

    Return result
EndFunction
