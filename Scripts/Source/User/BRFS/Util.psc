Scriptname BRFS:Util Hidden Const

BRFS:NPC[] Function GetAllActors(Float radius=-1.0) global
    Keyword[] selector = new Keyword[1]
    selector[0] = Game.GetFormFromFile(0x90B1, "FalloutSlavery.esp") as Keyword
    Return GardenOfEden.FindActors(selector, None, akOrigoRef=Game.GetPlayer(), afDistance=radius) as BRFS:NPC[]
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

ObjectReference Function GetActorOrMarkerByDisplayName(String name) global
    BRFS:MarkerController controller = Game.GetFormFromFile(0x90B6, "FalloutSlavery.esp") as BRFS:MarkerController

    ObjectReference result = controller.Get(name)
    If result
        Return result
    EndIf

    Return GetPlayerOrActorByDisplayName(name)
EndFunction

String Function GetName(ObjectReference ref, Bool skipMarkerName=False) global
    BRFS:MarkerController controller = Game.GetFormFromFile(0x90B6, "FalloutSlavery.esp") as BRFS:MarkerController

    String result = ref.GetDisplayName()
    If result && ! System:Strings.Contains(result, "not be visible")
        Return result
    EndIf

    result = ref.GetBaseObject().GetName()
    If result && ! System:Strings.Contains(result, "not be visible")
        Return result
    EndIf

    If ! skipMarkerName
        result = controller.GetMarkerName(ref)
        If result
            Return result
        EndIf
    EndIf

    Return System:Form.GetEditorID(ref.GetBaseObject())
EndFunction

Form Function GetForm(String id) global
    Int numId = System:Int32.TryParse(id, 16)
    If numId != 0
        Return Game.GetForm(numId)
    EndIf

    Return System:Form.GetByEditorID(id)
EndFunction

ObjectReference Function GetRef(String id) global
    If ! id || id == "s" || id == "selected"
        Return System:Game.GetCurrentCrosshairRef()
    EndIf

    Int numId = System:Int32.TryParse(id, 16)
    If numId != 0
        Return Game.GetForm(numId) as ObjectReference
    EndIf

    Return GetActorOrMarkerByDisplayName(id)
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
