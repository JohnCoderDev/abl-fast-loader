block-level on error undo, throw.

class classes.FastLoader.Shared.JsonMethodParameter:
    method public static Progress.Lang.ParameterList getParameter(pFieldName as character):
        define variable parameterResult as Progress.Lang.ParameterList no-undo.
        assign parameterResult = new Progress.Lang.ParameterList(1).
        parameterResult:setParameter(1, 'character', 'input', pFieldName).
        return parameterResult.
    end method.
    
    method public static Progress.Lang.ParameterList getParameter(pPosition as integer):
        define variable parameterResult as Progress.Lang.ParameterList no-undo.
        assign parameterResult = new Progress.Lang.ParameterList(1).
        parameterResult:setParameter(1, 'integer', 'input', pPosition).
        return parameterResult.
    end method.
end class.
