class classes.FastLoader.Errors.FastLoaderTargetNotAvailable inherits Progress.Lang.AppError:
    constructor FastLoaderTargetNotAvailable():
        addMessage('it was not possible to find a valid target in the FastLoader', -5005).
    end constructor.
end class.
