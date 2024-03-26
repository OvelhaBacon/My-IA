
local json = require("json")
local MessagePack = require("MessagePack")

function printtable(table)
    if type(table) ~= "table" then
        print("isso n é uma tabela :D")
        return
    end
    for i, v in pairs(table) do
        print(tostring(i) .. " = " .. tostring(v))
    end
end

function Sleep(seconds)
    os.execute("timeout " .. seconds)
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result;
end

function copyTable(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = copyTable(value)  -- Chamada recursiva para tabelas aninhadas
        else
            copy[key] = value
        end
    end
    return copy
end

function combinations(elements)
    local result = {}

    local function generate_combinations(current, start)
        local combination = {}
        for _, v in ipairs(elements) do
            table.insert(combination, "nul")
        end

        if #current > 0 then
            for i = 1, #current do
                combination[current[i]] = elements[current[i]]
            end
            table.insert(result, combination)
        end

        for i = start, #elements do
            table.insert(current, i)
            generate_combinations(current, i + 1)
            table.remove(current)
        end
    end

    generate_combinations({}, 1)
    return result
end

function fixstring(var)
    if type(var) ~= "string" then
        return tostring(var)
    else
        return '"' .. var .. '"'
    end
end

function tabletostring(table)
    local string = ""
    for i, v in pairs(table) do
        if type(v) == "table" then
            string = string .. "["..fixstring(i).."] = {\n" .. tabletostring(v) .. "},\n"
        else
            string = string .. "["..fixstring(i).."] = " .. fixstring(v) .. ",\n"
        end
    end
    return string
end


function writetable(arquivow,table)
    for i, v in pairs(table) do
        if type(v) == "table" then
            arquivow:write("["..fixstring(i).."] = {\n" .. tabletostring(v) .. "},\n")
        else
            arquivow:write("["..fixstring(i).."] = " .. fixstring(v) .. ",\n")
        end
    end
end

function dist2d(loc1, loc2)
    local deltaX = loc1[1] - loc2[1]
    local deltaY = loc1[2] - loc2[2]
    local distancia = math.sqrt(deltaX^2 + deltaY^2)
    return distancia
end

globals = {
    data = {
        decoramentos = {},
        aprendizados = {},
        score = 0,
    },
    trainingmode = true,
    minocorrencias = 8,
}

function limpaaprendizados()
    local aprendizados = globals.data.aprendizados
    for i, v in pairs(aprendizados) do
        local sotemnul = true
        for j, k in pairs(v) do
            if k[1] ~= false and k[3] > 2 then
                sotemnul = false
            else
                aprendizados[i][j] = nil
            end
        end
        if sotemnul then
            aprendizados[i] = nil
        end
    end
end

function savedata()
    print("salvando")
    local arquivow = io.open("C:/Users/Passaralho/Desktop/data1.txt", "w")
    arquivow:write(MessagePack.pack(globals.data))
    --arquivow:write(json.encode(globals.data))
    arquivow:close()
    print("salvo :D")
end

function loaddata()
    local arquivor = io.open("C:/Users/Passaralho/Desktop/data1.txt", "r")
    if not arquivor then savedata() return end
    local text = arquivor:read("*all")
    if text == "" then savedata() return end
    globals.data = MessagePack.unpack(text)
    --globals.data = json.decode(text)
    arquivor:close()
end



function randomvalue(tipo)
    if tipo == "b" then
        return math.random(0,1) == 0
    end

    if type(tipo) == "table" and type(tipo[1]) == "number" then
        return math.random(tipo[1], tipo[2])
    end

    if type(tipo) == "table" and type(tipo[1]) == "table" then
        local string = ""
        local chars = math.random(tipo[2][1], tipo[2][1])
        for i = 1, chars do
            string = string + tipo[1][math.random(1,#tipo[1])]
        end
        return string
    end


    print("tipo não configurado")
end

function randomoutput(outputs)
    outiputs = {}
    for i = 1, #outputs do
        table.insert(outiputs, randomvalue(outputs[i]))
    end
    return outiputs
end

function puttostring(put)
    string = ""
    for i = 1, #put do
        string = string .. tostring(put[i])
    end
    return string
end

function recreateinputs(inputs, combinacao)
    local temptable = {}
    for i = 1, #inputs do
        temptable[i] = "nul"
        for j = 1, #combinacao do
            if inputs[i] == combinacao[j] then
                temptable[i] =  combinacao[j]
                break
            end
        end
    end
    return temptable
end

function verifyrecriacao(inputs, recriacao)
    for i = 1, #inputs do
        if recriacao[i] ~= "nul" and inputs[i] ~= recriacao[i] then
            return false
        end
    end
    return true
end

function calc(inputs, outputs)
    local string = puttostring(inputs)

    local oqvairetorna = randomoutput(outputs)

    if not globals.trainingmode then
        print(string)
    end

    local temruim

    local tempoutput = randomoutput(outputs)
    local combinacoes = combinations(inputs)
    local tempstring

    for nove = 0, 6 do
        for i, v in pairs(combinacoes) do
            local stringe = puttostring(v)
            local negrice = globals.data.aprendizados[stringe]
            tempstring = puttostring(tempoutput)

            if negrice and ((negrice[tempstring] == nil) or (negrice[tempstring][1] == false) or negrice[tempstring][1] <= 0)  then

                for p, j in pairs(negrice) do
                    if j[1] ~= false and j[1] > 0 then
                        if not globals.trainingmode then
                            print(">"..stringe .. "|" .. p)
                        end
                        tempoutput = j[2]
                        goto continue
                    end
                end

                if nove >= 3 then
                    for p, j in pairs(negrice) do
                        if j[1] ~= false and j[1] >= 0 and j[3] > 5 then
                            if not globals.trainingmode then
                                print(">="..stringe .. "|" .. p)
                            end
                            tempoutput = j[2]
                            goto continue
                        end
                    end
                end
          

            end
        end

        ::continue::

        temruim = false
        for i, v in pairs(combinacoes) do
            local stringe = puttostring(v)
            local negrice = globals.data.aprendizados[stringe]
            tempstring = puttostring(tempoutput)
            if negrice then
                local j = negrice[tempstring]
                if j and j[1] ~= false and j[1] < 0 and j[3] > 10 then
                    if not globals.trainingmode then
                        print("<"..stringe .. "|" .. tempstring)
                    end
                    temruim = true
                    tempoutput = randomoutput(outputs)
                end
            end
        end
        if not temruim then break end
    end

    if not globals.trainingmode then
        print(temruim)
    end

    oqvairetorna = tempoutput

    return oqvairetorna
end

function applypoints(inputs, outputs, points)
    --local string = puttostring(inputs)
    local string2 = puttostring(outputs)

    for i, v in pairs(combinations(inputs)) do
        local stringe = puttostring(v)
        if globals.data.aprendizados[stringe] ~= false then
            if not globals.data.aprendizados[stringe] then
                globals.data.aprendizados[stringe] = {}
            end


            if globals.data.aprendizados[stringe][string2] then
                local modificante = globals.data.aprendizados[stringe]
                if modificante[string2][1] ~= false then
                    if modificante[string2][1] >= 0 and points < 0 then
                        modificante[string2] = {false}
                    elseif modificante[string2][1] < 0 and points >= 0 then
                        modificante[string2] = {false}
                    elseif modificante[string2][1] > 0 and points == 0 then
                        modificante[string2][1] = points
                    else
                        modificante[string2][3] = modificante[string2][3] + (modificante[string2][3] > 20 and 0 or 1)
                    end
                end
            else
                globals.data.aprendizados[stringe][string2] = {points, outputs, 0}
            end
        end
    end
end




local cobrinha = {
    map = {},
    corpo = {},
    dir = "Up",
    mapsize = 12, --tenq se divisivel por 2
    vivo = true,
    score = 0,
    foodloc = nil,
    tempovivo = 0,
}
function cobrinhaf()
    local maxtryes = globals.trainingmode and 50 or 1
    local printprct = math.floor(maxtryes * 0.05) == 0 and 1 or math.floor(maxtryes * 0.05)

    local dirs = {
        "Up",
        "Down",
        "Left",
        "Right",
    }
    local dirs2 = {
        ["Up"] = 1,
        ["Down"] = 2,
        ["Left"] = 3,
        ["Right"] = 4,
    }
    function mapgem()
        cobrinha.map = {}
        for i = 1, cobrinha.mapsize do
            cobrinha.map[i] = {}
            for v = 1, cobrinha.mapsize do
                cobrinha.map[i][v] = " "
            end
        end
        cobrinha.corpo = {}
        table.insert(cobrinha.corpo, {cobrinha.mapsize/2,cobrinha.mapsize/2})
        table.insert(cobrinha.corpo, {cobrinha.mapsize/2+1,cobrinha.mapsize/2})
        table.insert(cobrinha.corpo, {cobrinha.mapsize/2+2,cobrinha.mapsize/2})
        cobrinha.map[cobrinha.mapsize/2][cobrinha.mapsize/2] = "H"
        cobrinha.map[cobrinha.mapsize/2+1][cobrinha.mapsize/2] = "H"
        cobrinha.map[cobrinha.mapsize/2+2][cobrinha.mapsize/2] = "F"
    end

    function foodgen() 
        if cobrinha.foodloc ~= nil then return end
        local livres = {}
        for i = 1, cobrinha.mapsize do
            for v = 1, cobrinha.mapsize do
                if cobrinha.map[i][v] ==  " " then
                    table.insert(livres, {i,v})
                end
            end
        end
        if #livres == 0 then
            print("GANHOU")
        end
        local selected = livres[math.random(1,#livres)]
        cobrinha.foodloc = selected
        cobrinha.map[selected[1]][selected[2]] = "*"
    end

    function predictloc(loc1, dir)
        local loc = copyTable(loc1)
        if dir == "Up" then
            loc[1] = loc[1] - 1
        elseif dir == "Down" then
            loc[1] = loc[1] + 1
        elseif dir == "Right" then
            loc[2] = loc[2] + 1
        elseif dir == "Left" then
            loc[2] = loc[2] - 1
        else
            print("A DIREÇÂO TA PRETA")
        end
        return loc
    end

    function getmapchar(loc)
        if outofmap(loc) then
            return "X"
        end
        return cobrinha.map[loc[1]][loc[2]]
    end

    function outofmap(loc)
        if cobrinha.map[loc[1]] == nil or cobrinha.map[loc[1]][loc[2]] == nil then
            return true
        else
            return false
        end
    end

    function move(dir)

        cobrinha.map[cobrinha.corpo[#cobrinha.corpo][1]][cobrinha.corpo[#cobrinha.corpo][2]] = " "
        
        local lastbody = cobrinha.corpo[#cobrinha.corpo]

        for i = 1, #cobrinha.corpo-1 do
            local v = #cobrinha.corpo-i+1
            cobrinha.corpo[v] = {cobrinha.corpo[v-1][1],cobrinha.corpo[v-1][2]}
        end


        cobrinha.corpo[1] = predictloc(cobrinha.corpo[1], dir)


        if outofmap(cobrinha.corpo[1]) or cobrinha.map[cobrinha.corpo[1][1]][cobrinha.corpo[1][2]] == "H" then
            cobrinha.vivo = false
        elseif cobrinha.map[cobrinha.corpo[1][1]][cobrinha.corpo[1][2]] == " " then
            cobrinha.map[cobrinha.corpo[#cobrinha.corpo][1]][cobrinha.corpo[#cobrinha.corpo][2]] = "F"
        elseif cobrinha.map[cobrinha.corpo[1][1]][cobrinha.corpo[1][2]] == "*" then
            table.insert(cobrinha.corpo, lastbody)
            cobrinha.map[lastbody[1]][lastbody[2]] = "F"
            cobrinha.score = cobrinha.score + 1
            cobrinha.foodloc = nil
        end
        if cobrinha.vivo then
            cobrinha.map[cobrinha.corpo[1][1]][cobrinha.corpo[1][2]] = "H"
        end
    end

    function changedir(dir)
        if dir == "Left" and cobrinha.dir == "Right" then
            return
        end
        if dir == "Right" and cobrinha.dir == "Left" then
            return
        end
        if dir == "Up" and cobrinha.dir == "Down" then
            return
        end
        if dir == "Down" and cobrinha.dir == "Up" then
            return
        end
        if dir ~= nil and dirs2[dir] ~= nil then
            cobrinha.dir = dir
        end
    end

    function printmap()
        print("____________")
        for i = 1, cobrinha.mapsize do
            local string = ""
            for v = 1, cobrinha.mapsize do
                string = string .. cobrinha.map[i][v]
            end
            print(string)
        end
        print("------------")
    end

    local tryes = maxtryes
    while tryes > 0 do

        cobrinha.score = 0
        cobrinha.foodloc = nil
        cobrinha.dir = "Up"
        cobrinha.vivo = true
        cobrinha.tempovivo = 0
        mapgem()
        foodgen() 

        local lastdist = -5
        local lastscore = 0

        if not globals.trainingmode then
            printmap()
        end
        while cobrinha.vivo and cobrinha.tempovivo < 200 do
            local dire = nil

            --[[
            local inputs = {
                dirs2[cobrinha.dir],
                getmapchar(predictloc(cobrinha.corpo[1], "Up")),
                getmapchar(predictloc(cobrinha.corpo[1], "Down")),
                getmapchar(predictloc(cobrinha.corpo[1], "Left")),
                getmapchar(predictloc(cobrinha.corpo[1], "Right")),
                cobrinha.foodloc[1]-cobrinha.corpo[1][1], cobrinha.foodloc[2]-cobrinha.corpo[1][2]
            }
            ]]
            
            
            
            local inputs = {
                dirs2[cobrinha.dir], cobrinha.foodloc[1] - cobrinha.corpo[1][1], cobrinha.foodloc[2]-cobrinha.corpo[1][2],
                getmapchar(predictloc(cobrinha.corpo[1], "Up")),
                getmapchar(predictloc(cobrinha.corpo[1], "Down")),
                getmapchar(predictloc(cobrinha.corpo[1], "Left")),
                getmapchar(predictloc(cobrinha.corpo[1], "Right")),
            }
            for i = 2, #cobrinha.corpo do
                table.insert(inputs, cobrinha.corpo[i][1] - cobrinha.corpo[1][1])
                table.insert(inputs, cobrinha.corpo[i][2] - cobrinha.corpo[1][2])
            end
            
            
            
            local output = calc(inputs, {{1,4}})

            if not globals.trainingmode then
                print(output[1])
            end

            dire = dirs[output[1]]

            changedir(dire)
            move(cobrinha.dir)
            foodgen()
            if not globals.trainingmode then
                printmap()
            end
            cobrinha.tempovivo = cobrinha.tempovivo + 1

            local points = 0


            if cobrinha.score ~= lastscore then
                points = points + 4
                lastscore = cobrinha.score
                lastdist = -5
            end

            if lastdist ~= -5 then
                if dist2d(cobrinha.foodloc, cobrinha.corpo[1]) < lastdist then
                    points = points + 1
                end
            end
            lastdist = dist2d(cobrinha.foodloc, cobrinha.corpo[1])

            if not cobrinha.vivo then
                points = -10
                if not globals.trainingmode then
                    print("morreu")
                end
            end

            applypoints(inputs, output, points)

            if not globals.trainingmode then
                Sleep(0)
            end
        end

        if cobrinha.score > globals.data.score then
            print("melhoro :D " .. cobrinha.score)
            globals.data.score = cobrinha.score
        end

        if tryes % printprct == 0 then
            print((100 - (tryes/maxtryes)*100) .. "%")
            --savedata()
        end

        tryes = tryes - 1
    end

    print("100.0%")
    limpaaprendizados()
    savedata()
end



globals.trainingmode = true
loaddata()
cobrinhaf()



