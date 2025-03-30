block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.FastLoader.Shared.JsonPrimitive from propath.

class classes.FastLoader.Shared.JsonMethod:
    method public static Progress.Reflect.Method getMethod(pJson as JsonObject, pFieldName as character):
        define variable methodName as character no-undo.
        define variable primitiveType as character no-undo.
        define variable jsonParameter as Progress.Lang.ParameterList no-undo.
        
        assign 
            primitiveType = JsonPrimitive:getPrimitive(pJson, pFieldName)
            methodName = 'get' + primitiveType
            jsonParameter = new Progress.Lang.ParameterList(1).
        
        jsonParameter:setParameter(1, 'character', 'input', pFieldName).
        
        return pJson:getClass():getMethod(methodName, jsonParameter).
    end method.
    
    method public static Progress.Reflect.Method getMethod(pJson as JsonArray, pPosition as integer):
        define variable methodName as character no-undo.
        define variable primitiveType as character no-undo.
        define variable jsonParameter as Progress.Lang.ParameterList no-undo.
        
        assign
            primitiveType = JsonPrimitive:getPrimitive(pJson, pPosition)
            methodName = 'get' + primitiveType
            jsonParameter = new Progress.Lang.ParameterList(1).
        
        jsonParameter:setParameter(1, 'integer', 'input', pPosition).
        
        return pJson:getClass():getMethod(methodName, jsonParameter).
    end method.
end class.
