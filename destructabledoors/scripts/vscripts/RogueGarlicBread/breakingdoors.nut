/*
    [No more room in hell] - Destructable doors VScript.
    
    To use  :   Set up a prop door rotating with compatible door model;
                    example: models/props_door/roguebread/door01.mdl
                Set a keyvalue <vscripts> with value <RogueGarlicBread/breakingdoors.nut>
    Optional:   Env_shooter parented to the door.

    Configure the door with the below variables

    Credits:
     Script              - Thijs
     Original Door       - Contagion
     Ported and modified - Thijs
*/


self.ConnectOutput("OnTakeDamage", "Allwehadtodoooo")
printl("---Start door script---")

function Allwehadtodoooo()
function wastofollowthedamntrainnnnSeeGaye()


const startinghealth = 1000 //setting health as keyvalue seems broken: always gets set to 500. Instead, manually set in postspawn
const gibsCount     = 2
local door_stages   = [".mdl", "_damage01.mdl", "_damage02.mdl", "_damage03.mdl" ]    //change suffixes here to configure a different/new door

//define door's gibs in here:
local doorgibs  = [
    "models/props_door/gibs/door01_gib01.mdl",
    "models/props_door/gibs/door01_gib02.mdl",
    "models/props_door/gibs/door01_gib03.mdl",
    "models/props_door/gibs/door01_gib04.mdl",
    "models/props_door/gibs/door01_gib05.mdl",
    "models/props_door/gibs/door01_gib06.mdl",
    "models/props_door/gibs/door01_gib07.mdl",
    "models/props_door/gibs/door01_gib08.mdl",
    "models/props_door/gibs/door01_gib09.mdl"
]

//      variables
local healthincrement = 0
local damagestage = 1
local modelarr = []
local model
local sMyName = self.GetName()
local hGibshooter = null
local enablegibs    = true


//-------sounds-------
//"Wood_Furniture.Break"
//"BarricadeProp.Break"
//"Wood_Solid.Break"
//"Wood_Plank.Break"
//"Wood.Break"

local simpledamagesound = "Wood.Break"
local sSoundName = "Wood_Furniture.Break"

self.PrecacheSoundScript(simpledamagesound);
self.PrecacheSoundScript(sSoundName);
local sndParams = EmitSound_t();

sndParams.SetSoundName(sSoundName);
sndParams.SetFlags(0);
sndParams.SetSoundLevel(SNDLVL_120dB);
sndParams.SetChannel(CHAN_AUTO);
EmitSoundParamsOn(sndParams, self);
self.GetOrCreatePrivateScriptScope().sndParams <- sndParams; // store obj on ent
//--------------------



function OnPostSpawn()
{    
    self.SetHealth(startinghealth)
    healthincrement = startinghealth / door_stages.len()

    //get model basename
    modelarr = split(self.GetModelName(), ".")
    model = modelarr[0]
    
    for (local n = 0; n < door_stages.len(); n++)   //precache stages:
    {
        PrecacheModel(model+door_stages[n], true)
    }
    if (enablegibs) 
    {
        hGibshooter = self.FirstMoveChild() //get gibshooter and store its handle
        if(hGibshooter == null) 
        {
            enablegibs = false
            return
        }
        hGibshooter.AcceptInput( "AddOutput", "m_iGibs 1", self, self ) //keyvalues get reset for some reason
        hGibshooter.AcceptInput( "AddOutput", "m_flVelocity 50", self, self ) 

        for (local i=0; i<doorgibs.len(); i++)          //precache gibs:
            PrecacheModel(doorgibs[i], true)
    }
}

function Allwehadtodoooo()  //handle hp change
{
    local requiredhealth = startinghealth - damagestage*healthincrement

    if (self.GetHealth() < requiredhealth && self.GetHealth() >= 0)
    {
        wastofollowthedamntrainnnnSeeGaye()
        EmitSoundParamsOn(sndParams, self)

        if (enablegibs)
            for (local i=0; i < gibsCount;i++)
                youPickedTheWrongHouseFool()

        damagestage++
        if (damagestage>2)
            self.AcceptInput("Unlock", "", self, self)
    }
    else if (self.GetHealth() < 0)
        self.DisconnectOutput("OnTakeDamage", "OnTakeDamageHook")   
    else
        self.EmitSound(simpledamagesound)
}

function wastofollowthedamntrainnnnSeeGaye()    //do door breakage
{
    self.SetModel(model+door_stages[damagestage])
}

function youPickedTheWrongHouseFool()       // do door gibs
{
    hGibshooter.AcceptInput( "AddOutput", "m_iGibs ", self, self ) //keyvalues get reset for some reason
    hGibshooter.AcceptInput( "AddOutput", "m_flVelocity 50", self, self ) 

    //randomnize doorpiece
    local randomgib = RandomInt(0, (doorgibs.len() -1) )
    hGibshooter.AcceptInput( "AddOutput", "shootmodel " + doorgibs[ randomgib ], self, self )
    hGibshooter.AcceptInput( "Shoot", "", self, self )
}