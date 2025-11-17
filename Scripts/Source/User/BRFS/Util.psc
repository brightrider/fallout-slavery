Scriptname BRFS:Util Hidden Const

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
