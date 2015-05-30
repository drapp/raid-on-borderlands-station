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

+ airlockDoor: LockableWithKey, Door 'large square steel station airlock' 'airlock'
    "This was the main entrance for individual human traffic in and out of the station. It's banged up, but no way you\'re prying this open. There's a keycard slot for entrance, wouldn't want anyone just wandering in here. "
    keyList = [keyCard]
    
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
      airlockInnerDoor.makeLocked(nil);
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
    
    north = airlockInnerDoor
;
+ me: Actor
    pcDesc = "Stella Nova"
;

++ Container 'large white space bag*bags' 'space bag'
    "a bag, but in spaaace"
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

+ airlockInnerDoor: IndirectLockable, Door 'large square steel station airlock' 'airlock'
    "The airlock inner door is all that stands between you and the station"
    
    makeOpen(stat)
    {
        inherited(stat);
    }
        
;

+ Enterable -> airlockInnerDoor 'large square steel station airlock' 'airlock'
    "It's a steel airlock door"
;

atrium: DarkRoom 'The Atrium'
    "The Atrium is a charnal house. You dearly hope your suit's air filters are
up to the task. It makes no sense, there's no sign of a riot, a war, or
depressurization. If not for the smell this room would probably still be
habitable. Just bodies everywhere. You put the mystery out of your head and try
to focus on the room itself.<.p>
If not for the improptu morgue, the atrium would be an utterly mundane and functional room, laid out optimally for the business of station customs and security just like dozens of such places you'd seen on other stations. A marblish counter down the center of the room served as a staging ground from which piratical customs agents would perform the most heinous of tax crimes against ordinary citizens and outlanders wanting to conduct business with the station. To either side prim velvet ropes delinated neat queues, now push asckew by falling bodies. A <<if holoscreen.moved>>holoscreen lies on the ground next to a safe is built into <<else>> holoscreen hangs on <<end>>the west wall, thankfully shorted out and not displaying cheery tourism advertisements, which would have been too much in the circumstances. To the east is the ship bay where most traffic would have entered the station. To the west is some sort of eatery. To the north is a closed door, and to the south is the airlock leading out of the station."
    south = airlockInnerDoorInside
    east = bay
    west = eatery
    out asExit(south)
    roomDarkDesc {"It's pitch black. Fortunately the last of the Grues were
elimiated during the imperial succession war a century prior, or you'd be
worried right now.<.p> Your suit totally has a light on it, but for some
reason, you just can't think of the voice command needed to activate it. That
makes no sense, you use the command all the time. When you think about it, the
words are there in your head, but they're all scrambled up like some sort of
jigsaw puzzle.";}
;
+ airlockInnerDoorInside : Lockable, Door -> airlockInnerDoor 'door' 'door'; 

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

android : Person 'sad android' 'android'
  @bay
  "A humanoid robot with an outsized head, conical hat protrusion, and a permanently sad expression. "
  properName = 'Sad Android' 
  globalParamName = 'android'
  isHim = true
; 

+ ConvNode 'heart'; 

++ SpecialTopic
  name = 'remind him of his heart'
  keywordList = ['companion', 'cube']
  topicResponse {
      "<q>Yes, of course, the weighted companion cube, I loved that bit from Portal!</q> the robot exclaims, his permanently sad expression taking on a wistful cast. <q>Here, you should have this</q>. He takes a companion cube out of his chest and places it on the floor. ";
   companionCube.discover();
  }
; 

+ DefaultGiveShowTopic, ShuffledEventList
  [
    '<q>That won\'t fill the void</q> intones the robot<.convnode heart>',
    '<q>I think you ought to know I\'m feeling very depressed.</q><.convnode heart>',
    '<q>What is this cupped cake?</q> says the robot in a German accent for some reason<.convnode heart>',
    '<q>Thanks for noticing me</q> drones the robot in a gloomy voice.<.convnode heart>'
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
    '<q>Dammit robot, answer me!</q> you shout.<.p>
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
  specialDesc = "A robot is blocking your path. "
  discovered = true
; 

+ GiveShowTopic @catster
  topicResponse
  { 
      "<q>Ah, that will do nicely!</q> the robot exclaims, and snatches the magazine from your hands. He crabwalks over to the bathroom door and hurridly scramles inside, slamming it behind him. ";
  bathroom.discover();
  robot.discovered = false;
}
; 

+ DefaultGiveShowTopic, ShuffledEventList
  [
    'No, that won\'t do at all. ',
    'I don\'t know how it works for humans, but that won\'t work for me. ',
    'I\'m confused how you think the mechanics of this work. '
  ]
; 


eatery: DarkRoom 'Eatery'
  "<<if robot.discovered>> You can see it's an eatery, but you can't make out any details. <<else>> This would have been a fairly seedy dive commisary at one point. In stark contrast to the workmanlike metal interiors of the rest of the staion, this place feature fake wood panelling, fake windows, and fake old timey charm. <<end>>"

  east = atrium
;

+ bathroom: Decoration 'bathroom' 'bathroom door'
    "A bathroom door, with the picture of a robot on it"
    
    notImportantMsg = 'I don\'t think you want to go in there, it sounds like bad things are happening'
    isHidden = true
;

//X ZCSA BLGO ZCO JKSO. OGOJAZCO WXVBRN, CZ ZCO FKXRN. AZK EZC'R EZ AZKJ QZI; X'SS NBZZR AZK. AZK VOR DO? TOSYZDO RZ RBO JZKVBCOYPN.
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
