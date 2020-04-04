ItemDictionary = {
    SPRUCE_WOOD = 17,
    SPRUCE_SAPLING = 2,
    CHARCOAL = 263
}

SlotIndexes = {
    FUEL_SLOT = 1,
    WOOD_SLOT = 2,
    SAPLING_SLOT = 3
}

function pause()
    write("*** Appuyez sur une touche pour continuer ! *** \n");
    read();
end

--------------------------------
-- La turtle à besoin de fuel --
--------------------------------
function doesNeedRefuel()
    return turtle.getFuelLevel() < 1500;
end

--------------------------------------------------------
-- Remonte le niveau de fuel jusqu'à un seuil minimum --
--------------------------------------------------------
function executeRefuel()
    turtle.select(SlotIndexes.FUEL_SLOT);
    turtle.turnRight();
    turtle.suck();
    turtle.refuel();
    turtle.turnLeft();
end

--
-- find tree
--
function findTree()
    bool, meta = turtle.inspect();
    return bool or meta == 'minecraft:log';
end

--
--
--
function harvestTree()
    turtle.turnLeft();
    if findTree() then
        fellTree();
        plantTree();
    end
    turtle.turnRight();
end

--
--
--
function fellTree()
    turtle.select(SlotIndexes.WOOD_SLOT);
    turtle.dig();
    turtle.forward();

    local i = 0;
    bool, meta = turtle.inspectUp();
    while meta.name == 'minecraft:log' do
        turtle.digUp();
        turtle.up();
        i = i+1;
        bool, meta = turtle.inspectUp();
    end

    for j=0, i-1, 1 do
        turtle.down();
    end

    turtle.back();
end

--
--
--
function plantTree()
    print('plant');
end

------------------------------------------------
-- Routine pour chaque étape de la patrouille --
------------------------------------------------
function step()
    turtle.forward();
end

-------------------------------------
-- Patrol sur un rectangle de 13x8 --
-------------------------------------
function harvestPatrol()
        
    for i=0,11,1 do 
        step();
        if i == 0 or i ==  5 or i == 10 then
            harvestTree();
        end
    end

    turtle.turnLeft();
    for i=0,6,1 do
        step();
    end

    turtle.turnLeft();
    for i=0,11,1 do
        step();
        if i == 0 or i ==  5 or i == 10 then
            harvestTree();
        end
    end

    turtle.turnLeft();
    for i=0,6,1 do
        step();
    end

    turtle.turnLeft();
end


function pickupPatrol()
        checkFuel()
        
        -- 1er aller
        for i=0,14,1 do suck() print(i.."/14") end
        
        --1er retour
        turtle.turnLeft()
        suck()
        suck()
        suck()
        turtle.turnLeft()
        for i=0,11,1 do suck() print(i.."/11") end
        
        -- 2eme aller
        turtle.turnRight()
        suck()
        suck()
        suck()
        turtle.turnRight()
        for i=0,11,1 do suck() print(i.."/11") end
        
        --2eme retour
        turtle.turnLeft()
        suck()
        suck()
        turtle.turnLeft()
        for i=0,11,1 do suck() print(i.."/11") end

        -- retour a la base
        turtle.turnLeft()
        for i=0,7,1 do suck() print(i.."/7") end

        -- parking
        turtle.turnLeft()
        turtle.back()
        turtle.back()
        turtle.back()
end

-- demande la procedure de refuel manuel
function manualRefuel(minimum)
    minimum = minimum or 1500
    
    local answer,x,y,fuelLevel
    local fuelOK = false
    
    -- ask confirmation
    repeat
        print("niveau de fuel insuffisant, refueling manuel nécessaire pour continuer le programme, voulez-vous lancer la procédure (y/n)")
        answer = io.read()
    until answer=="y" or answer=="n"
    if answer=="n" then exit() end
    
    while not fuelOK do
        turtle.refuel()
        x,y = term.getCursorPos()
        term.setCursorPos(1,y-1)
        term.clearLine()
        fuelLevel = turtle.getFuelLevel()
        write("insérez du fuel dans le slot 1 ("..fuelLevel.."/"..minimum..")")
        fuelOK = fuelLevel >= minimum
        sleep(1)
    end
    
end

-- Renvoie true ssi toute la checklist est OK
function TurtleStatus()	
    shell.run('clear')
    print("demarrage de la Turtle bûcheron\n")
    textutils.slowPrint(" ### checklist ###\n")
    textutils.slowWrite("Vérification Fuel (1500) ...")
    
    turtle.select(1)
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel < 1500 then
        textutils.slowWrite("\t\tERROR\n")
        manualRefuel()
    else
        textutils.slowWrite("\t\tOK\n")
    end
    
    turtle.select(2)
    textutils.slowWrite("Vérification echantillion à récolter ...")
    if turtle.getItemCount(2) >= 1 then
        textutils.slowWrite("\t\tOK\n")
    else
    textutils.slowWrite("\t\tERROR\n")
        manualWood()
    end
    
    turtle.select(3)
    textutils.slowWrite("Vérification echantillion de saplings ...")
    if turtle.getItemCount(3) > 9 then
        textutils.slowWrite("\t\tOK\n")
    else
        textutils.slowWrite("\t\tERROR\n")
        manualSapling()
    end
end


---------------------
-- start checklist --
---------------------
-- turtleStatus()

shell.run('clear');
print('START');

while true do

    if doesNeedRefuel() then
        executeRefuel();
    end

    harvestPatrol();
    sleep(15);
end