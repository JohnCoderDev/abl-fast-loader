block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.

class classes.FastLoader.Sources.FLSJsonArray inherits classes.FastLoader.Interfaces.ASourceLoader:
    define private property jsonKeys as character extent get. set.
    define private property json as JsonArray get. set.
    
    constructor FLSJsonArray():
        super().
    end constructor.
    
    method public override void loadHeaders(input-output pSource as Progress.Lang.Object):
    end method.
    
    method public override void loadData(input-output pSource as Progress.Lang.Object):
    end method.
end class.
