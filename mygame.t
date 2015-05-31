#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID
    IFID = '558d20af-6559-477a-9f98-b7b4274cd304'
    name = 'Raid on Borderlands Station'
    byline = 'by Douglas Rapp'
    htmlByline = 'by <a href="mailto:douglas.rapp@gmail.com">
                  Douglas Rapp</a>'
    version = '1'
    authorEmail = 'Douglas Rapp<douglas.rapp@gmai.com>'
    desc = 'Escape the space cafe using external paper puzles'
    htmlDesc = 'Escape the space cafe using external paper puzles'
;

gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
    
    showIntro()
    {
        "<b>Raid on Borderlands Station</b>\nThree months ago Borderlands
Station, once a thriving outpost on the edge of inhabited space, went dark. The
fate of the more than 3000 citizen and outlanders estimated to be aboard is
unknown, but the complete silence on all channels does not bode well. More
ominous, however, was that none of the ships known to be docked at the station
have been heard from either. The station was a patchwork mess to begin with,
and this far from civilization competent maintainers would be hard to come by.
Any number of accidents might have befallen the semi-legal smuggling outpost,
and that would be the end of it. Before too long another station held together
with glue and curses would have taken its place and that would be that. But
anything that could disable both the station and the ships silently, without a
teltale gigantic explosion, was a threat of a different order, and the galactic
protectorate had taken notice. You also took notice, and with your speedy ship
Pudding you've outpaced the official response by a solid week. And now the
station lies before you ready for plunder.<.p>
You are Stella Nova, famed rogue and general badass, and you know a profitable
situation when you see it. Whatever destroyed this station scares the
protectorate, and if you can get ahold of it the bidding war will be furous and profitable. You've left your ship behind, and now you're outside the station ready to face whatever you find inside.<.p>";
    }
;

startRoom: OutdoorRoom 'Station Entrance'
    "The outside of the space station stretches before you like a wall, the
curvature bearly noticable from this close up. You're at the main airlock door
a reinforced steel behemoth about four meters square. the rest of the hull is a jigsaw of weld patches, intricate but uninteresting, except for an outcropping 15 meters above you in your current reference frame. Behind you is the endless black of space, peppered by stars and the indistinguishable dot of your ship" 
    
    north = airlockDoor
    in asExit(north)
    up = hull
    cannotGoThatWayMsg = 'No sense wandering off, this station is enormous and you only have so much oxygen\b'
roomDescVerbose = nil
;

//me 
+ me: Actor
    pcDesc = "Stella Nova"
;

++ Container 'large white space bag*bags' 'space bag'
    "a bag, but in spaaace"
;

+ airlockDoor: LockableWithKey, Door 'large square steel station airlock' 'airlock'
    "This was the main entrance for individual human traffic in and out of the station. It's banged up, but no way you\'re prying this open. There's a keycard slot for entrance, wouldn't want anyone just wandering in here. "
    keyList = [keyCard]
    initiallyLocked = true
    
    makeOpen(stat)
    {
        inherited(stat);
        "You insert the keycard and a green light blinks. That's a relief, you had other options for entering the station, but none of them good";
    }
    
        
;

hull: OutdoorRoom 'Hull'
    "You're on the hull on the side of the space station" 
    
    down = startRoom
    cannotGoThatWayMsg = 'No sense wandering off, this station is enormous and you only have so much oxygen\b'
roomDescVerbose = nil
;

+ loosePatch: ComplexContainer 'small steel hull plate patch' 
    'loose hull patch sticking out'
    "This bit of hull is loose, it doesn't seem to be essential for station integrity"
    subContainer: ComplexComponent, Container { bulkCapacity = 3}
    subUnderside: ComplexComponent, Underside { }
    dobjFor(Search) asDobjFor(Take)
    dobjFor(Pull) asDobjFor(Take)
    dobjFor(Open) asDobjFor(Take)

	actionDobjTake()  
	{  
      "It breaks off in your hand. ";
      inherited;
      "Never underestimate people's laziness when it comes to security. ";
    }
      
    
    bulk = 3
    bulkCapacity = 3
;

++ keyCard: Hidden, Key 'small plastic keycard*keycards' 'keycard'
    "a key card, used for entering things" 
    subLocation = &subUnderside 
;

+ Enterable -> airlockDoor 'large square steel station airlock' 'airlock'
    "It's a steel airlock door with a keycard slot for entering"

  destName = 'The airlock'
;

+ Decoration 'patch welds' 'welds'
    "This station is held together with glue and promises"
    
    notImportantMsg = 'They\'re welded shut, you don\'t have the equpiment to open them and you don\'t want to destroy the station'
    isPlural = true
;

terminal : Actor 'terminal' 'terminal'
  @airlock
  "A terminal screen with a speaker"
  properName = 'Terminal' 
  globalParamName = 'terminal'
  isIt = true
  initSpecialDesc = "A terminal sits on one wall. You should talk to it"
; 

+ ConvNode 'password-input'; 

++ SpecialTopic
  name = 'say the passphrase'
  keywordList = ['the', 'humans', 'are', 'prey']
  topicResponse {
      "PASSWORD ACCEPTED. DOOR UNLOCKED";
      stationDoor.makeLocked(nil);
  }
; 
 
++ DefaultAnyTopic "INVALID PASSWORD. YOU WILL BE EXTERMINATED";

+ terminalTalking : InConversationState
  stateDesc = "The terminal is flashing an ascii face" 
  specialDesc = "The terminal is ready for input"
;

++ terminalWorking : ConversationReadyState
  stateDesc = "The terminal is blank"
  isInitState = true
;

+++ HelloTopic, StopEventList
  [
    'A PASSPHRASE IS REQUIRED. \b
     14-10-16\b
     30-5-65\b
     39-4-38\b
     31-7-12\b<.convnode password-input>',
    'PLEASE GIVE THE PASSWORD <.convnode password-input>'
  ]
;

airlock: Room 'Airlock'
    "You are in the airlock, which is at the southern edge of the station according to local geography. The walls are boring and metalic, with pump nozzels in the corners to pump air in and out. "
    
    north = stationDoor
;


+ corpse:Fixture, Container 'dead desicated corpse' 'corpse'
    "The corpse of a station official is slumped against the side of the wall. His face stares at you with an expression of horror "
  initSpecialDesc = "The corpse of a station official is slumped against the side of the wall. His face stares at you with an expression of horror. You're momentarily startled, but you expected this, and at least it's not gruesome. You don't see any obvious cause of death"
;

++ catster: Hidden 'catster magazine' 'copy of Catster Magazine from Spring 2015'
 actionDobjTake()      
{
    inherited;
    "Strange that he would have such an ancient artifact. This magazine looks terrible, a rare phystical remnant from the BuzzFeed Cultural Black Hole of the early 21st century";
}
;

+ airlockDoorInside : Lockable, Door -> airlockDoor 'door' 'door'; 

+ stationDoor: IndirectLockable, Door 'large square steel station airlock' 'airlock'
    "The airlock inner door is all that stands between you and the station"
    
    makeOpen(stat)
    {
        inherited(stat);
    }
        
;

+ Enterable -> stationDoor 'large square steel station airlock' 'airlock'
    "It's a steel airlock door"
;

atrium: DarkRoom 'The Atrium'
    "The Atrium is a charnal house. You dearly hope your suit's air filters are
up to the task. It makes no sense, there's no sign of a riot, a war, or
depressurization. If not for the smell this room would probably still be
habitable. Just bodies everywhere. You put the mystery out of your head and try
to focus on the room itself.<.p>
If not for the improptu morgue, the atrium would be an utterly mundane and functional room, laid out optimally for the business of station customs and security just like dozens of such places you'd seen on other stations. A marblish counter down the center of the room served as a staging ground from which piratical customs agents would perform the most heinous of tax crimes against ordinary citizens and outlanders wanting to conduct business with the station. To either side prim velvet ropes delinated neat queues, now push asckew by falling bodies. A <<if holoscreen.moved>>holoscreen lies on the ground next to a safe is built into <<else>> holoscreen hangs on <<end>>the west wall, thankfully shorted out and not displaying cheery tourism advertisements, which would have been too much in the circumstances. To the east is the ship bay where most traffic would have entered the station. To the west is some sort of eatery. To the north is a closed door, the sort used by cleaning robots, and to the south is the airlock leading out of the station. "
    south = stationDoorInside
    east = bay
    west = eatery
    north = closetDoor
    out asExit(south)
    roomDarkDesc {"It's pitch black. Fortunately the last of the Grues were
elimiated during the imperial succession war a century prior, or you'd be
worried right now.<.p> Your suit totally has a light on it, but for some
reason, you just can't think of the voice command needed to activate it. That
makes no sense, you use the command all the time. When you think about it, the
words are there in your head, but they're all scrambled up like some sort of
jigsaw puzzle.";}
;


+ stationDoorInside : Lockable, Door -> stationDoor 'door' 'door'; 

+ corpse2: Decoration 'dead body corpse' 'corpse'
    "Corpses are littered about the place, a wide swath of ex-humanity all all manner of military and civilian wear. There's no blood, no signs of stuggle, but it's a grizzly sight nonetheless"
    
    notImportantMsg = 'Enough with the corpses already. This is supposed to be a birthday party!'
;
    
+ holoscreen: RoomPartItem, Thing 'blank holoscreen/screen' 
    'holoscreen'
    "A screen that would normally show promotional images and safety warnings"
    
    initNominalRoomPartLocation = defaultWestWall
    initSpecialDesc = "A blank holoscreen hangs on the west wall"
    isListed = (moved)
    
    bulk = 8
    
    dobjFor(LookBehind)
    {
        action()
        {
            if(moved)
                inherited;
            else
            {
                safe.discover();
                "Behind the holoscreen is a quantum safe built into the wall. As you jostle it, the screen flickers on, which is disconcerting given that it's not attached to a power source. Rather than cheery images of the station, however, it displays a weird grid and a series of statements about people you vaguely recognize as pre-scattering folk heroes.";
            }
        }
    }
    
    moveInto(newDest)
    {
        if(!safe.discovered)
        {
            "Removing the holoscreen from the wall reveals a safe behind. It also flickers on, which is disconcerting given that it's not attached to a power source. Rather than cheery images of the station, however, it displays a weird grid and a series of statements about people you vaguely recognize as pre-scattering folk heroes.";
            safe.discover();
        }
        inherited(newDest);
    }
;

+ safe: RoomPartItem, Hidden, CustomFixture, ComplexContainer 
    'quantum safe' 'safe'
    "It's a quantum safe with a single entanglement dial on its door. "
    
    subContainer: ComplexComponent, IndirectLockable, OpenableContainer 
    { 
        bulkCapacity = 5 
        makeOpen(stat)
        {
            inherited(stat);
        }
        
    }
    
    specialDesc = "A quantum safe is built into the west wall. "
    specialNominalRoomPartLocation = defaultWestWall
    cannotTakeMsg = "It's literally a part of the wall"
    
    discover()
    {
        if(!discovered)
        {
            foreach(local cur in allContents)
                cur.discover();
            
        }
        inherited();
    }
    
;

++ safeDoor:  Hidden, ContainerDoor '(safe) door' 'quantum safe door'
    "It has an entanglement dial on its front. "         
;

+++ safeDial: Hidden, Component,  NumberedDial 'circular dial*dials' 'dial'
    "The entanglement dial can be tuned to any number between <<minSetting>> and
    <<maxSetting>>. It's currently at <<curSetting>>. "
    
    minSetting = 0
    maxSetting = 9999
    curSetting = '356'
    
    num1 = 0
    num2 = 0
    correctCombination = 15893047
    
    makeSetting(val)
    {
        inherited(val);
        num2 = num1;
        num1 = toInteger(val);
        if(10000 * num2 + num1 == correctCombination)
        {
            "You hear a slight <i>bzzzzz</i> come from the safe door. ";
            safe.makeLocked(nil);
        }
        else if(!safe.isOpen)
            safe.makeLocked(true);
    }
;

++ muonTransfusor: Thing 'muon transfuser' 'muon transfuser'
    "the solution to all your muon transfusing needs"

    subLocation = &subContainer
;


+ closetDoor: IndirectLockable, Door 'alumninum door' 'closet door'
    "A door for janitor robots to park themselves and recharge"
    makeOpen(stat)
    {
        inherited(stat);
        "The door opens for the vacuumba and you immediately wedge it open. ";
    }
        
;

+ Enterable -> closet 'aluminum door' 'close door'
    "It's a closet door for cleaning robots"
;

android : Person 'sad android' 'android'
  @bay
  "A humanoid android with an outsized head, conical hat protrusion, and a permanently sad expression. "
  properName = 'Sad Android' 
  globalParamName = 'android'
  isHim = true
; 

+ ConvNode 'heart'; 

++ SpecialTopic
  name = 'remind him of his heart'
  keywordList = ['companion', 'cube']
  topicResponse {
      "<q>Yes, of course, the weighted companion cube, I loved that bit from Portal!</q> the android exclaims, his permanently sad expression taking on a wistful cast. <q>Here, you should have this</q>. He takes a companion cube out of his chest and places it on the floor. ";
   companionCube.discover();
  }
; 

+ DefaultGiveShowTopic, ShuffledEventList
  [
    '<q>That won\'t fill the void</q> intones the android<.convnode heart>',
    '<q>I think you ought to know I\'m feeling very depressed.</q><.convnode heart>',
    '<q>What is this cupped cake?</q> says the android in a German accent for some reason<.convnode heart>',
    '<q>Thanks for noticing me</q> drones the android in a gloomy voice.<.convnode heart>'
  ]
; 


+ androidTalking : InConversationState
  stateDesc = "He seems to be paying attention to you, maybe" 
  specialDesc = "{The android/he} might be talking to you, or he might not. "
;

++ androidBeingSad : ConversationReadyState
  stateDesc = "He's busy being sad"
  specialDesc = "<<a++ ? '{The android/he}' : '{An android/he}'>> 
  is standing near a space ship just generally being sad"
  isInitState = true
  a = 0
;

+++ HelloTopic, StopEventList
  [
    'You cautiously approach the android, who doesn\'t react to you. <q>Hey!</q> you bark out. <q>What is your status? What happened here?</q><.p>
     The android\'s eyes flick up at you briefly, then sag back down <q>I seem to have lost my heart. I can\'t even remember what it was. I think I may have locked it away in a box</q><.convnode heart>',
    '<q>Dammit android, answer me!</q> you shout.<.p>
     <q>Without my heart, it\'s all meaningless</q> {the android/he} sobs.<.convnode heart> '
  ]
; 

bay: DarkRoom 'Ship Bay'
  "The ship bay is fairly small, containing three corvette-class ships and a dozen or so shuttles."

  west = atrium
;

+ companionCube : Chair, Hidden 'weighted companion cube' 'companion cube'
  "It's just a regular old cube with hearts painted on the side"
; 

robot : Person, Hidden 'antsy robot' 'robot'
  @eatery
  "A robot blocks your path. It's larger than the door, so you can't get around it, with a rectangular humanoid frame and circular head. It's making a pained face, squeezing its legs together and shuffles side to side."
  properName = 'Antsy robot' 
  globalParamName = 'robot'
  isHim = true
  specialDesc = "A robot is blocking your path. It's larger than the door, so you can't get around it, with a rectangular humanoid frame and circular head. It's making a pained face, squeezing its legs together and shuffles side to side."
  discovered = true
; 

+ GiveShowTopic @catster
  topicResponse
  { 
      "<q>Ah, that will do nicely!</q> the robot exclaims, and snatches the magazine from your hands. He crabwalks over to the bathroom door and hurridly scramles inside, slamming it behind him. ";
  bathroom.discover();
  robot.discovered = nil;
  vacuumba.discover();
}
; 

+ DefaultGiveShowTopic, ShuffledEventList
  [
    'No, that won\'t do at all. ',
    'I don\'t know how it works for humans, but that won\'t work for me. ',
    'I\'m confused how you think the mechanics of this work. '
  ]
; 

+ DefaultAnyTopic, ShuffledEventList
  [
    'I could use some help here',
    'I\'ve been like this for years',
    'Ohhh, dear...',
    'Please, you know what I need'
  ]
; 


eatery: DarkRoom 'Eatery'
  "<<if robot.discovered>> You can see it's an eatery, but you can't make out any details. <<else>> This would have been a fairly seedy dive commisary at one point. In stark contrast to the workmanlike metal interiors of the rest of the staion, this place feature fake wood panelling, fake windows, and fake old timey charm. <.p>

The bathroom door is on the north wall. <<end>>"

  east = atrium
;

+ vacuumba: Thing, Hidden 'roomba robot vacuumba' 'vacummba'
  "This little fellow vacuums the floor, does your laundry, styles your hair, makes breakfast, and who knows what else. <<if broken>>It appears to be broken, a heartbreaking lack of muons. If you had a muon transfuser you could fix it, those cost a fortune; no one would just leave one lying around. <<else>> It's beeping and booping happily, looks like it wants to be charged. <<end>>"
  broken = true
  specialDesc = "A vacuumba lies on the floor. "
;

+ bathroom: Decoration 'bathroom' 'bathroom door'
    "A bathroom door, with the picture of a robot on it"
    
    notImportantMsg = 'I don\'t think you want to go in there, it sounds like bad things are happening'
    isHidden = true
;

closet: DarkRoom 'vacuumba closet'
  "A vacuumba closet, filled with all manner of vacuumba. An air vent on the ceiling. There's a big <q>h</q> on one wall, and a sudoku looking diagram on the other wall"
    south = closetDoorInside
    out asExit(south)
    up : TravelMessage 
{  ->shaft1
    "Standing on the companion cube you manage to haul yourself into an air vent"
        canTravelerPass(traveler) 
        { return traveler.isIn(companionCube) && traveler.posture==standing; }
    explainTravelBarrier(traveler) 
    { "You're a few inches short of grabbing the edge of the air vent, even when jumping. "; 
} 
}      
;
+ closetDoorInside : Lockable, Door -> closetDoor 'door' 'door'; 

//h
shaft1: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaft2
  south = shaftConfused
  east = shaftConfused
  west = shaftConfused
  down = closet
;

//c
shaft2: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaftConfused
  south = shaftConfused
  east = shaft3
  west = shaftConfused
  down = closet
;

//f
shaft3: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaft4
  south = shaftConfused
  east = shaftConfused
  west = shaftConfused
  down = closet
;

//i
shaft5: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaftConfused
  south = shaftConfused
  east = shaft6
  west = shaftConfused
  down = closet
;

//g
shaft6: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaft7
  south = shaftConfused
  east = shaftConfused
  west = shaftConfused
  down = closet
;

//f
shaft7: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaft8
  south = shaftConfused
  east = shaftConfused
  west = shaftConfused
  down = closet
;

//b
shaft8: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaftConfused
  south = shaftConfused
  east = end
  west = shaftConfused
  down = closet
;

//a
shaft4: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. " 
  north = shaftConfused
  south = shaftConfused
  east = shaft5
  west = shaftConfused
  down = closet
;

shaftConfused: Room 'air shaft'
  "You're in a nameless metalic air shaft with exits on all four sides. you could also probably kick down into whatever lies below. You feel a bit strange and dizzy, it's hard to keep track of where you are. "
  north = shaftConfused
  south = shaftConfused
  east = shaftConfused
  west = shaftConfused
  down = closet
;



// END-------------------------------------------


end: Room 'Control Center'
  "You are in the station control center, with blank monitors and keypads lining the walls. A strange assortment of robotic entities stand around the room.<.p>

We are the galactic puzzle council. We have grown tired of artfully working puzzles into your adventure, so we have brought you here to face your final tests"
  solved = 0
  puzzleCount = 3
  win {
    "</p> The robots turn to you and say in chorus <q>You have triumphed over every obstacle we set in front of you</q> intones the chorus of robots. <q>We destroyed the inhabitants of this station when they were unable to solve our arbitrary logic puzzles, and we were about to wipe out the rest of humanity. Those without puzzling abilities do not deserve to live, and our puzzle robot clan has vowed to exterminate the unworthy. You have restored our faith in the human race as a puzzling species with your mighty deeds, and so we will leave you in peace to improve your logical reasoning abilities. Now we must go, may you puzzle and propagate!</q>

Well that was lame, you think. Then you pillage the hell out of the station and head back to your ship with a enough plunder to never work again. As you fly off in your ship to you next adventure, for some reason you think <q>Happy Birthday Michelle</q>";
    finishGameMsg(ftVictory, []); 
  }
;


// Superman

+ superman : Person 'robot superman' 'superman robot'
  "A strange robot, shaped like an update down triange and wearing the tattered remains of a superman outfit. "
  properName = 'Superman' 
  globalParamName = 'superman'
  specialDesc = "A robot dressed like superman stands to one side"
  isHim = true
; 

++ AskTopic @weirdo
   "Don't mine him, he's just grumpy that everyone forgot his character."
; 

++ ConvNode 'supermanpuzzle'; 

+++ SpecialTopic
  name = 'answer the puzzle'
  keywordList = ['volcano']
  topicResponse {
      "Indeed, my heart rages like a volcano! ";
    end.solved++;
    if(end.solved == end.puzzleCount) end.win();
  }
; 

++ supermanPuzzling : InConversationState
  stateDesc = "Give him the puzzle answer" 
  specialDesc = "Superman is talking to you"
;

+++ supermanIdle : ConversationReadyState
  stateDesc = "He's busy being sad"
  specialDesc = "The superman robot stands trying to look noble, but he looks like a stiff breeze would topple his lopsided frame. "
  isInitState = true
;

++++ HelloTopic, StopEventList
  [
    'Greetings earthling, there\'s a puzzle inside me, I can feel it<.convnode supermanpuzzle>'
  ]
; 

// bug weirdo

+ weirdo : Person 'bug batman weirdo' 'weirdo'
  "An unusual robot dressed in black and grey. It's got two little tufts on its head, and kind of looks like a bug or something, and it has an emblem on its chest that might be a moth. If this is some figure from ancient earth, its name has be lost in the mists of time. You decide to call it Bug Wierdo"
  properName = 'Bug Weirdo' 
  globalParamName = 'weirdo'
  specialDesc = "An unusual robot dressed in black and grey leans in a corner looking sulky. It's got two little tufts on its head, and kind of looks like a bug or something. If this is some figure from ancient earth, its name has be lost in the mists of time. You decide to call it bug wierdo"
  isHim = true
; 
++ AskTopic @superman
   "Smug bastard, he's not the night."
; 

++ ConvNode 'weirdopuzzle'; 

+++ SpecialTopic
  name = 'answer the puzzle'
  keywordList = ['firefly']
  topicResponse {
      "No, I'm a bat, I am the night! But that is the answer";
    end.solved++;
    if(end.solved == end.puzzleCount) end.win();
  }
; 

++ weirdoPuzzling : InConversationState
  stateDesc = "Give him the puzzle answer" 
  specialDesc = "Bug weirdo is talking to you"
;

+++ weirdoIdle : ConversationReadyState
  stateDesc = "He's busy being sad"
  specialDesc = "He makes a broodyface"
  isInitState = true
  a = 0
;

++++ HelloTopic, StopEventList
  [
    'I am the night! <.convnode weirdopuzzle>',
    'Stahp it, am the night! <.convnode weirdopuzzle>'
  ]
; 

// space marine

+ spaceMarine : Person 'space marine' 'space marine'
  "A robot dressed, rather redundantly, in power armor."
  properName = 'Space Marine' 
  globalParamName = 'marine'
  specialDesc = "To your right stands a robot dressed, rather redundantly, in power armor. It's looking gruff."
  isHim = true
; 
++ AskTopic @superman
   "That soft human doesn't even have power armor"
; 

++ ConvNode 'marinepuzzle'; 

+++ SpecialTopic
  name = 'say what his favorite movie is'
  keywordList = ['starship', 'troopers']
  topicResponse {
      "Come on, you damned dirty apes! Do you wanna live forever?";
    end.solved++;
    if(end.solved == end.puzzleCount) end.win();
  }
; 

++ marinePuzzling : InConversationState
  stateDesc = "Give him the puzzle answer" 
  specialDesc = "Bug marine is talking to you"
;

+++ marineIdle : ConversationReadyState
  stateDesc = "He's busy being sad"
  specialDesc = "He makes a broodyface"
  isInitState = true
;

++++ HelloTopic, StopEventList
  [
    'X ZCSA BLGO ZCO JKSO. OGOJAZCO WXVBRN, CZ ZCO FKXRN. AZK EZC\'R EZ AZKJ QZI; X\'SS NBZZR AZK. AZK VOR DO? TOSYZDO RZ RBO JZKVBCOYPN. <.convnode marinepuzzle>'
  ]
; 

//------------------------------------------------------------------------------

DefineIAction(FiatLux)
 execAction
{
  if(gPlayerChar.brightness == 0)
  {
    "Your suit light switches on and you can see again\n";
    gPlayerChar.brightness = 3;
  }
  else
  {
    "You switch your suit light off. ";
    gPlayerChar.brightness = 0;
  }
}
;

VerbRule(FiatLux)
  'fiat' 'lux'
  : FiatLuxAction
  verbPhrase = 'make/making light'
; 

DefineIAction(Fix)
 execAction
{
  if(vacuumba.isIn(gPlayerChar) && muonTransfusor.isIn(gPlayerChar)) {
      "The vacuumba beeps and boops happily, then hops from your hand and goes to the closet, which opens for it";
      closetDoor.makeLocked(nil);
  } else {
    "Nothing to fix";
  }
}
;

VerbRule(Fix)
  'fix'
  : FixAction
  verbPhrase = 'fix'
; 

DefineIAction(Unlockus)
 execAction
{
      closetDoor.makeLocked(nil);
}
;

VerbRule(Unlockus)
  'unlockus'
  : UnlockusAction
  verbPhrase = 'just unlock the door'
; 
