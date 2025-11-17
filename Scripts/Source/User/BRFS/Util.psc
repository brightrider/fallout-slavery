Scriptname BRFS:Util Hidden Const

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
