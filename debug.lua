local debug = {}

function debug:enterFunction()
    print("enter", currentState, debug.getinfo(1, "n").name)
end

function debug:leaveFunction()

end