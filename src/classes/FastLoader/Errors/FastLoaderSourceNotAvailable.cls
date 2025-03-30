class classes.FastLoader.Errors.FastLoaderSourceNotAvailable inherits Progress.Lang.AppError:
    constructor FastLoaderSourceNotAvailable():
        addMessage('it was not possible to find a valid source in the FastLoader', -5006).
    end constructor.
end class.
