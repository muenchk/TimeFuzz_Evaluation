-- Determines the result of a test
-- Available Globals
--   input - Pointer to the current input
-- Available Functions
--   string         Input_GonvertToPython(InputPtr)                     - converts the input sequence to a python list
--   boolean        Input_IsTrimmed(InputPtr)                           - returns whether the executed input sequence is smaller than the generated
--   void           Input_Trim(InputPtr, int length)                    - trims the input sequence to [length] elements
--   nanoseconds    Input_GetExecutionTime(InputPtr)                    - returns the runtime of the PUT
--   int            Input_GetExitCode(InputPtr)                         - returns the exitcode of the PUT
--   int            Input_GetSequenceLength(InputPtr)                   - returns the length of the input sequence
--   string         Input_GetSequenceFirst(InputPtr)                    - returns the first entry of the input sequence
--   string         Input_GetSequenceNext(InputPtr)                     - returns the next entry of the input sequence
--   int            Input_GetExitReason(InputPtr)                       - returns the reason for PUT exit
--                  -- 0        - PUT still running
--                  -- 1        - PUT has exited on its own 
--                  -- 2        - last input was given to the PUT and killed after timeout
--                  -- 4        - PUT has been terminated
--                  -- 8        - PUT has been terminated after reaching the timeout
--                  -- 16       - PUT has been terminated after a fragment timeout
--                  -- 32       - PUT has been terminated due to excessive memory consumption
--                  -- 1024     - PUT couldn't be started
--   string         Input_GetCmdArgs(InputPtr)                          - returns the cmd args the PUT was started with
--   string         Input_GetOutput(InputPtr)                           - returns the PUT's output on stdout and stderr
--   int            Input_GetReactionTimeLength(InputPtr)               - returns the length of the reaction time list (only available in fragment mode)
--   nanoseconds    Input_GetReactionTimeFirst(InputPtr)                - returns the first reactiontime
--   nanoseconds    Input_GetReactionTimeNext(InputPtr)                 - returns the next reactiontime
--   void           Input_SetPrimaryScore(InputPtr, double)             - sets the primary score for the input
--   void           Input_SetSecondaryScore(InputPtr, double)           - sets the secondary score for the input
--   void           Input_EnablePrimaryScoreIndividual(InputPtr)        - enables individual primary scores
--   void           Input_EnableSecondaryScoreIndividual(InputPtr)      - enables individual secondary scores
--   void           Input_AddPrimaryScoreIndividual(InputPtr, double)   - adds an individual primary score
--   void           Input_AddSecondaryScoreIndividual(InputPtr, double) - adds an individual secondary score
--   void           Input_ClearScores(InputPtr)                         - clears all set scores
--   void           Input_ClearTrim(InputPtr)                           - clears trim status of input
--   void           Input_GetRetries(InputPtr)                          - number of times the input was re-run
-- Return Value
--      -- 0    - unfinished (input is unfinished and can be extended)
--      -- 1    - passing
--      -- 2    - failing
--      -- 4    - undefined (unknown)
--      -- 64   - input is a prefix of an already known input
function Oracle()
    -- check for exit reason and co
    exitreason = Input_GetExitReason(input)
    if (exitreason == 16 or exitreason == 32 or exitreason == 4) then
        return 2
    elseif (exitreason == 8) then
        return 0 -- unfinished  // stuck at obstacle
    elseif (exitreason == 1024) then
        if (Input_GetRetries(input) < 5) then
            return 128 -- try again
        else
            return 4
        end
    end

    output = Input_GetOutput(input)
    
    lines = {}
    i = 1
    for str in string.gmatch(output, "([^\n]*)\n") do
        lines[i] = str
        i = i + 1
    end

    str_pos_x = 0
    str_pos_y = 0
    lng = 0

    for c = 1,#lines do
        char = lines[c]:sub(1,1)
        if (char == "0" or char == "1" or char == "2" or char == "3" or char == "4" or char == "5" or char == "6" or char == "7" or char == "8" or char == "9") then
            strings = {}
            x = 1
            for str in string.gmatch(lines[c], "([^,]*)") do
                strings[x] = str
                x = x + 1
            end
            if (x >= 2) then
                lng = lng + 1
                str_pos_x = strings[1]
                str_pos_y = strings[2]
            end
        end
    end
    
    pos_x = tonumber(str_pos_x)
    if (pos_x ~= nil) then
        Input_SetPrimaryScore(input, pos_x)
    end

    if lng - 101 > 0 and Input_GetSequenceLength(input) ~= lng - 101 then
        Input_Trim(input, lng - 101)
        return 2 -- failing
    end

    if (Input_GetExitCode(input) > 0) then
        return 1
    end

    pos_y = tonumber(str_pos_y)
    if (pos_y ~= nil) then
        if (pos_y < 40 or Input_GetSequenceLength(input) ~= lng - 101) then
            --print("falling\n")
            return 2
        else
            return 0
        end
    else
        return 4
    end
end