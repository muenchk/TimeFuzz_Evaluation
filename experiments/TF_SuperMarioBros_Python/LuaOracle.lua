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
--                  -- 64       - PUT has been terminated due to a pipe error
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
-- Return Value
--      -- 0    - unfinished (input is unfinished and can be extended)
--      -- 1    - passing
--      -- 2    - failing
--      -- 4    - undefined (unknown)
--      -- 64   - input is a prefix of an already known input
function Oracle()
    -- check for exit reason and co
    exitreason = Input_GetExitReason(input)
    if (exitreason == 8 or exitreason == 16 or exitreason == 32 or exitreason == 4) then
        return 2
    elseif (exitreason == 1024 or exitreason == 64) then
        if (Input_GetRetries(input) < 5) then
            return 128 -- try again
        else
            return 4
        end
    end
    output = Input_GetOutput(input)
    primaryscore = 0
    secondaryscore = 0
    executed = 0
    inputlen = Input_GetSequenceLength(input)
    -- find primaryscore:XXX:
    begin = string.find(output, "primaryscore:")
    if (begin ~= nil) then
        sub = string.sub(output, begin + 13)
        send = string.find(sub, ":")
        if (send == nil) then
            -- output is somehow cut off, tra to repeat
            if (Input_GetRetries(input) < 5) then
                Input_ClearScores(input)
                return 128 -- try again
            else
                return 4
            end
        end
        sub = string.sub(sub, 0, send - 1)
        --primaryscore = tonumber(sub)
        --if (primaryscore ~= nil) then
        --    Input_SetPrimaryScore(input, primaryscore)
        --end
        
        -- we've got a lot of small strings, so get them all
        Input_EnablePrimaryScoreIndividual(input)
        scores = {}
        i = 1
        for str in string.gmatch(sub, "[^|]+") do
            scores[i] = str
            Input_AddPrimaryScoreIndividual(input, tonumber(str))
            i = i + 1
        end
        primaryscore = tonumber(scores[i-1])
        if (primaryscore ~= nil) then
            Input_SetPrimaryScore(input, primaryscore)
        end

    end
    -- find secondaryscore:XXX:
    begin = string.find(output, "secondaryscore:")
    if (begin ~= nil) then
        sub = string.sub(output, begin + 15)
        send = string.find(sub, ":")
        if (send == nil) then
            -- output is somehow cut off, tra to repeat
            if (Input_GetRetries(input) < 5) then
                Input_ClearScores(input)
                return 128 -- try again
            else
                return 4
            end
        end
        sub = string.sub(sub, 0, send - 1)
        --secondaryscore = tonumber(sub)
        --if (secondaryscore ~= nil) then
        --    Input_SetSecondaryScore(input, secondaryscore)
        --end
        
        scores = {}
        i = 1
        for str in string.gmatch(sub, "[^|]+") do
            scores[i] = str
            i = i + 1
        end
        secondaryscore = tonumber(scores[i-1])
        if (secondaryscore ~= nil) then
            Input_SetSecondaryScore(input, secondaryscore)
        end
    end
    -- find executed:XXX:
    begin = string.find(output, "executed:")
    if (begin ~= nil) then
        sub = string.sub(output, begin + 9)
        send = string.find(sub, ":")
        if (send == nil) then
            -- output is somehow cut off, tra to repeat
            if (Input_GetRetries(input) < 5) then
                Input_ClearScores(input)
                return 128 -- try again
            else
                return 4
            end
        end
        sub = string.sub(sub, 0, send - 1)
        executed = tonumber(sub)
        if (executed ~= nil) then
            Input_Trim(input, executed)
        end
    end
    -- calculate oracle
    exitcode = Input_GetExitCode(input)
    if (exitcode == 1) then
        print("done")
        return 1 -- passing input
    end
    if (executed == inputlen) then
        return 0 -- the PUT did process all inputs, but we couldn't get a resolution
    else
        return 2 -- we didn't finish the entire sequence, and didn't pass either, so we must have failed
    end
end