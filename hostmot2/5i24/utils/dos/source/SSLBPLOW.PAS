{ SSLBPLOW.PAS}
{ can't include because of duplicate names SSLBPINC.PAS}
{I sslbpinc}

type
CSRRec = record
  Error : byte;
  Status : byte;
  State : byte;
  WhatIam : byte;
end;

const
AxisStride = 4;
TheBasePort = $378;
Requestbit = $2000;
Writebit   = $8000;
Doitbit =    $1000;
Startbit =   $0800;
StandardRPC = 0; { for standardstart }
AltRpc      = 1;

SSLBPMajorRevisionLoc = 2;
SSLBPMinorRevisionLoc = 3;
SSLBPChannelStartLoc =  4;
SSLBPChannelStrideLoc = 5;
SSLBPProcessorType =    6;
SSLBPNumberOfChannels = 7;

SSLBPClock         = $230;
SSLBPDividend       =  50;

{ChanDisableCRCOffset = 30;}
{ChanBaudrateOffset = 42;}
chanrecvstringOffset        =      0;              { (ptr) 16 bytes, first to be able to use offsets }
chanstateOffset             =      16;             { (byte) state }
chanerrorOffset             =      17;             { (byte) bitfield of error bits }
chanerrorlogOffset          =      18;             { (byte) bitfield of sticky errorbits }
chanstatusOffset            =      19;             { (byte) status }
chancrccountOffset          =      20;             { (byte)  }
chancookiecountOffset       =      21;             { (byte)  }
chanoverruncountOffset      =      22;             { (byte)  }
chantimeoutcountOffset      =      23;             { (byte)  }
chanextracharcountOffset    =      24;             { (byte)  }
chanbreakcountOffset        =      25;             { (byte)  }
chanremfaultcountOffset     =      26;             { (byte)  }
chanerrorcountOffset        =      27;             { (byte) required number of errors to cause status error }
chanLBPdatasizeOffset       =      28;             { (byte)  }
chanidOffset                =      29;             { (byte) id byte for 8I20,7I64  }
chandisablecrcOffset        =      30;             { (byte)  }
chanclrfaultcountOffset     =      31;             { (byte)  }
{ NUchandatabase		$	%uint	base for data discovery }
chanchktoomanyerrsOffset    =      32;             { (byte) true at startup, false after blather }
chanstarttimeOffset         =      33;             { (uint) start of timeout }
chantimeoutOffset           =      35;             { (byte) error when deltatime is greater }
changenericOffset           =      36;             { (byte) nonzero if generic }
chanremfaultOffset          =      37;             { (byte)  }
chanwhatiamOffset           =      38;             { (ulong)  }
chanbaudrateOffset          =      42;             { (ulong)  }
chanRPCrecvsizeOffset       =      46;             { (byte)  }
chanRPCxmitsizeOffset       =      47;             { (byte)  }
chanmeasuredtimeOffset      =      48;             { (byte)  }
NUchanLBPcompatOffset       =      49;             { (byte) read from remote }

type
StateParamRec =
record
  ParmName : string[24];
  ParmLoc  : longint;
end;

const
StateLastParm = 68;
StateParams : array[1 .. StateLastParm] of StateParamRec =
((ParmName : 'reset'; ParmLoc : 0),
(ParmName : 'starttimer'; ParmLoc : 1),
(ParmName : 'waittimeout'; ParmLoc : 2),
(ParmName : 'requestcookie'; ParmLoc : 3),
(ParmName : 'getcookie'; ParmLoc : 4),
(ParmName : 'setlbptimeout'; ParmLoc : 5),
(ParmName : 'checksetlbptimeout'; ParmLoc : 6),
(ParmName : 'clrlbpstatus'; ParmLoc : 7),
(ParmName : 'checkclrlbpstatus'; ParmLoc : 8),
(ParmName : 'requestlbpstatus'; ParmLoc : 9),
(ParmName : 'getlbpstatus'; ParmLoc : 10),
(ParmName : 'checklbpstatus'; ParmLoc : 11),
(ParmName : 'requestunitnumber'; ParmLoc : 12),
(ParmName : 'getunitnumber'; ParmLoc : 13),
(ParmName : 'requestid0'; ParmLoc : 14),
(ParmName : 'getid0'; ParmLoc : 15),
(ParmName : 'requestid1'; ParmLoc : 16),
(ParmName : 'getid1'; ParmLoc : 17),
(ParmName : 'requestid2'; ParmLoc : 18),
(ParmName : 'getid2'; ParmLoc : 19),
(ParmName : 'requestid3'; ParmLoc : 20),
(ParmName : 'getid3'; ParmLoc : 21),
(ParmName : 'checkid0'; ParmLoc : 22),
(ParmName : 'checkid1'; ParmLoc : 23),
(ParmName : 'clear7I64faults'; ParmLoc : 24),
(ParmName : 'check7I64faults'; ParmLoc : 25),
(ParmName : 'setswmode'; ParmLoc : 26),
(ParmName : 'checkswmode'; ParmLoc : 27),
(ParmName : 'requestdiscovery'; ParmLoc : 28),
(ParmName : 'getdiscovery'; ParmLoc : 29),
(ParmName : 'cleargen'; ParmLoc : 30),
(ParmName : 'checkcleargen'; ParmLoc : 31),
(ParmName : 'setgenclrfaults'; ParmLoc : 32),
(ParmName : 'chksetgenclrfaults'; ParmLoc : 33),
(ParmName : 'reqgenclrfaults'; ParmLoc : 34),
(ParmName : 'getgenclrfaults'; ParmLoc : 35),
(ParmName : 'reqgenfaults'; ParmLoc : 36),
(ParmName : 'getgenfaults'; ParmLoc : 37),
(ParmName : 'chkgenfaults'; ParmLoc : 38),
(ParmName : 'setclrfaults'; ParmLoc : 39),
(ParmName : 'checksetclrfaults'; ParmLoc : 40),
(ParmName : 'requestclrfaults'; ParmLoc : 41),
(ParmName : 'getclrfaults'; ParmLoc : 42),
(ParmName : 'requestfaults'; ParmLoc : 43),
(ParmName : 'getfaults'; ParmLoc : 44),
(ParmName : 'checkfaults'; ParmLoc : 45),
(ParmName : 'clearsetpoint'; ParmLoc : 46),
(ParmName : 'checkclearsetpoint'; ParmLoc : 47),
(ParmName : 'setpidena'; ParmLoc : 48),
(ParmName : 'checksetpidena'; ParmLoc : 49),
(ParmName : 'requestpidon'; ParmLoc : 50),
(ParmName : 'getpidon'; ParmLoc : 51),
(ParmName : 'checkpidon'; ParmLoc : 52),
(ParmName : 'requestpidonfaults'; ParmLoc : 53),
(ParmName : 'getpidonfaults'; ParmLoc : 54),
(ParmName : 'checkpidonfaults'; ParmLoc : 55),
(ParmName : 'setwatchdog'; ParmLoc : 56),
(ParmName : 'checksetwatchdog'; ParmLoc : 57),
(ParmName : 'blather0'; ParmLoc : 58),
(ParmName : 'blather1'; ParmLoc : 59),
(ParmName : 'send8I20'; ParmLoc : 60),
(ParmName : 'recv8I20'; ParmLoc : 61),
(ParmName : 'send7I64'; ParmLoc : 62),
(ParmName : 'recv7I64'; ParmLoc : 63),
(ParmName : 'sendLBP'; ParmLoc : 64),
(ParmName : 'recvLBP'; ParmLoc : 65),
(ParmName : 'sendgeneric'; ParmLoc : 66),
(ParmName : 'recvgeneric'; ParmLoc : 67));

StopMode =    $000;
StopAllMode = $0FF;
NormalMode =  $100;
SetupMode =   $700;

Doitcommand  = Doitbit;

Stopcommand = Startbit+StopMode;
StopAllcommand = Startbit+StopMode;

Startcommand = Startbit+NormalMode;
StartSetupcommand = Startbit+SetupMode;

CommandShift = 24;
{ChannelReadyMask = $80;}

ReadByteCommand = (LBPCOMMAND_byte+LBPA2_byte+LBPD1_byte) shl CommandShift;
ReadWordCommand = (LBPCOMMAND_byte+LBPA2_byte+LBPD2_byte) shl CommandShift;
ReadLongCommand = (LBPCOMMAND_byte+LBPA2_byte+LBPD4_byte) shl CommandShift;
ReadDoubleCommand = (LBPCOMMAND_byte+LBPA2_byte+LBPD8_byte) shl CommandShift;

WriteByteCommand = (LBPCOMMAND_byte+LBPWRITE_byte+LBPA2_byte+LBPD1_byte) shl CommandShift;
WriteWordCommand = (LBPCOMMAND_byte+LBPWRITE_byte+LBPA2_byte+LBPD2_byte) shl CommandShift;
WriteLongCommand = (LBPCOMMAND_byte+LBPWRITE_byte+LBPA2_byte+LBPD4_byte) shl CommandShift;
WriteDoubleCommand = (LBPCOMMAND_byte+LBPWRITE_byte+LBPA2_byte+LBPD8_byte) shl CommandShift;

var
SSerial : byte; { for 2nd module }
CommandPort : word;
OurDataPort : word;
CSRPort : word;
InterfacePort0 : word;
InterfacePort1 : word;
InterfacePort2 : word;
NumberOfBases : byte;
SSLBPChannelStride : byte;
SSLBPChannelStart : byte;
SSLBPMajorRevision : byte;
SSLBPMinorRevision : byte;

procedure ShowSSLBPState(enum : longint);
var
index : integer;
state : string;
begin
  state := 'Invalid State';
  index := 1;
  while (((StateParams[index].ParmLoc <> enum)) and
        (index <= StateLastParm)) do index := index +1;
  if index < StateLastParm then  state := StateParams[index].ParmName; { cannonical name}
  writeln('State = ',state);
end;



procedure ShowSSLBPRemoteFaults(err : byte);
begin
  if err <> 0 then
  begin
    write('RemoteFaults:');
    if err and $01 <> 0 then write(' Watchdog');
    if err and $02 <> 0 then write(' Noenable');
    if err and $04 <> 0 then write(' Overtemp');
    if err and $08 <> 0 then write(' Overcurrent');
    if err and $10<> 0 then write(' HighVoltage');
    if err and $20 <> 0 then write(' LowVoltage');
    if err and $40 <> 0 then write(' ModeSetting');
    if err and $80 <> 0 then write(' LBPRemComm');
    writeln;
  end;
end;

procedure ShowSSLBPErrors( errstring : string; err : byte);
begin
  if err <> 0 then
  begin
    write(errstring,' Errors:');
    if err and $01 <> 0 then write(' CRC');
    if err and $02 <> 0 then write(' Cookie');
    if err and $04 <> 0 then write(' Overrun');
    if err and $08 <> 0 then write(' Timeout');
    if err and $10<> 0 then write(' Extrachar');
    if err and $20 <> 0 then write(' Breakchar');
    if err and $40 <> 0 then write(' Remfault');
    if err and $80 <> 0 then write(' Toomany');
    writeln;
  end;
end;

procedure ShowAllSSLBPErrors(csrval : longint);
begin
  ShowSSLBPErrors('',byte(csrval));
  if (byte(csrval) and $40) <> 0 then ShowSSLBPRemoteFaults(longintbyterec(csrval).byte3);
end;


procedure ShowSSLBPStatus(s : byte);
begin
  if s <> 0 then
  begin
    write('Status:');
    if s and $80 <> 0 then write(' NoBlather');
    if s and $40 <> 0 then write(' NoID');
    if s and $20 <> 0 then write(' Error');
    if s and $01 <> 0 then write(' RemoteFault');
    writeln;
  end;
end;

procedure SSLBPDump(theaxis : byte);
begin
  write('Command Port ');
  hexprint(Read32(CommandPort+(theaxis*AxisStride)),4);
  writeln;
  write('Data Port ');
  hexprint(Read32(OurDataPort+(theaxis*AxisStride)),2);
  writeln;
  write('CSR Port ');
  hexprint(Read32(CSRPort+(theaxis*AxisStride)),8);
  writeln;
  write('User0 ');
  hexprint(Read32(InterfacePort0+(theaxis*AxisStride)),8);
  writeln;
  write('User1 ');
  hexprint(Read32(InterfacePort1+(theaxis*AxisStride)),8);
  writeln;
  write('User2 ');
  hexprint(Read32(InterfacePort2+(theaxis*AxisStride)),8);
  writeln;
end;

function SSLBPReadCardName(theaxis : byte) : string;
var
  namenumber : longint;
  name : string[4];
begin
  name := '';
  namenumber := Read32(InterfacePort1+(theaxis*AxisStride));
  name := name + char(LongIntByteRec(namenumber).Byte0);
  name := name + char(LongIntByteRec(namenumber).Byte1);
  name := name + char(LongIntByteRec(namenumber).Byte2);
  name := name + char(LongIntByteRec(namenumber).Byte3);
  SSLBPReadCardName := name;
end;

function CheckForReady(theaxis : byte) : boolean;
var
csr : longint;
begin
  csr := Read32(CSRPort+(theaxis*AxisStride));
  if CSRRec(csr).Status = 0 then CheckForReady := true else CheckForReady := false;
end;

function CheckForErrors(theaxis : byte) : boolean;
var
csr : longint;
begin
  csr := Read32(CSRPort+(theaxis*AxisStride));
  if CSRRec(csr).Error <> 0 then CheckForErrors := true else CheckForErrors := false;
end;

procedure Waitfordone; { timed }
var
done : longint;
loops,time : longint;
begin
  loops := 100000;
  time := 0;
  repeat
    begin
      done := Read32(CommandPort);
      loops := loops -1;
      time := time +1;
      {delay(1);}
    end;
  until (done = 0) or (loops = 0);
{$IFDEF DEBUG}
  writeln('WaitForDone Time in ms ',time,' Loops= ',loops);
{$ENDIF DEBUG}
  if loops = 0 then
  begin
    writeln('Timeout waiting for done');
    SSLBPDump(Axis);
    halt(2);
  end;
end;

function WaitforStart : boolean; { false if timed out }
var
done : longint;
loops,time : longint;
begin
  loops := 1000; { for bootstrap }
  time := 0;
  repeat
    begin
      done := Read32(CommandPort);
      loops := loops -1;
      time := time +1;
      delay(1);
    end;
  until (done = 0) or (loops = 0);
{$IFDEF DEBUG}
  writeln('WaitForStart Time in ms ',time,' Loops= ',loops);
{$ENDIF DEBUG}
  if loops = 0 then WaitForStart := false else WaitForStart := true;
end;

function WaitforStartSetup : boolean; { false if timed out }
var
done : longint;
loops,time : longint;
begin
  loops := 200;
  time := 0;
  repeat
    begin
      done := Read32(CommandPort);
      loops := loops -1;
      time := time +1;
      delay(1);
    end;
  until (done = 0) or (loops = 0);
{$IFDEF DEBUG}
  writeln('StartSetup Time in ms ',time,' Loops= ',loops);
{$ENDIF DEBUG}
  if loops = 0 then WaitForStartSetup := false else WaitForStartSetup := true;
end;

function Start(bitmask : byte) : byte;
begin
  Write32(CommandPort,Startcommand+bitmask);
  if not WaitForStart then Start := $FF else Start := byte(Read32(OurDataPort));
end;

function StartSetup(bitmask : byte) : byte;
begin
  Write32(CommandPort,StartSetupcommand+bitmask);
  if not WaitForStartSetup then StartSetup := $FF else StartSetup := byte(Read32(OurDataPort));
end;

function AxisStartSetup(theaxis : byte) : boolean; { true if success }
var bitaxis,returnbyte : byte;
begin
  bitaxis := 1 shl theaxis;
  returnbyte := StartSetup(bitaxis);

  AxisStartSetup := (returnbyte = 0);
end;

function AxisStart(theaxis : byte) : boolean; { true if success }
var bitaxis,returnbyte : byte;
begin
  bitaxis := 1 shl theaxis;
  returnbyte := Start(bitaxis);
  AxisStart := (returnbyte and bitaxis = 0);
end;

procedure SSLBPStop(bitmask : byte);
begin
  Write32(CommandPort,StopCommand+bitmask);
  Waitfordone;
end;

procedure SSLBPStopAll;
var i : integer;
begin
  Write32(CommandPort,StopAllCommand);
  Waitfordone;
  for i := 0 to 7 do Write32(CSRport+(i*AxisStride),0);
end;

procedure AxisStop(theaxis : byte);
var bitaxis : byte;
begin
  bitaxis := 1 shl theaxis;
  Write32(CommandPort,StopCommand+bitaxis);
  Waitfordone;
  Write32(CSRport+(theaxis*AxisStride),0);
end;

function DoItNoWait(bitmask : byte) : byte;
begin
  if Read32(CommandPort) <>0 then
  begin
    writeln('Not ready for command ');
    SSLBPDump(Axis);
    halt(2);
  end;
  Write32(CommandPort,Doitcommand+bitmask);
  DoitNoWait := byte(Read32(OurDataPort));
end;

function DoIt(bitmask : byte) : byte;
var cmdreg : longint;
begin
  cmdreg := Read32(CommandPort);
  if cmdreg <>0 then
  begin
    write('Not ready for command, ','Command port reads 0x');
    hexprint(cmdreg,8);
    writeln;
    SSLBPDump(Axis);
    halt(2);
  end;
  Write32(CommandPort,Doitcommand+bitmask);
  WaitforDone;
  Doit := byte(Read32(OurDataPort));
end;

function AlwaysDoIt(bitmask : byte) : byte;
var
testbitmask : byte;
begin
  if Read32(CommandPort) <>0 then
  begin
    writeln('Not ready for command ');
    SSLBPDump(Axis);
    halt(2);
  end;
  Write32(CommandPort,Doitcommand+bitmask);
  Waitfordone;
  AlwaysDoit := byte(Read32(OurDataPort));
end;

function AxisDoItNoWait(theaxis : byte) : boolean;
var bitaxis : byte;
begin
  bitaxis := 1 shl theaxis;
  AxisDoItNoWait := (DoItNoWait(bitaxis) and bitaxis) =0;
end;

function AxisDoIt(theaxis : byte) : boolean;
var bitaxis : byte;
begin
  bitaxis := 1 shl theaxis;
  AxisDoIt := (DoIt(bitaxis) and bitaxis) =0;
end;

procedure SSLBPInit;
begin
  Write32(CommandPort,$4000);
  Write32(CommandPort,$0000);
end;


function SSLBPReadLBP(theaxis : byte;cmd : byte) : byte;
var acommand : longint;
begin
  LongIntByteRec(acommand).Byte3 := cmd;
  LongIntByteRec(acommand).Byte2 := 0;
  LongIntByteRec(acommand).Byte1 := 0;
  LongIntByteRec(acommand).Byte0 := 0;
  Write32(CSRport+(theaxis*AxisStride),acommand);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  SSLBPReadLBP := byte(Read32(InterfacePort0+(theaxis*AxisStride)));
  Write32(CSRport+(theaxis*AxisStride),0);
end;

function SSLBPReadWord(theaxis : byte;add : word) : word;
begin
  Write32(CSRport+(theaxis*AxisStride),ReadWordCommand+add);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  SSLBPReadWord := word(Read32(InterfacePort0+(theaxis*AxisStride)));
  Write32(CSRport+(theaxis*AxisStride),0);
end;

function SSLBPReadByte(theaxis : byte;add : word) : byte;
begin
  Write32(CSRport+(theaxis*AxisStride),ReadByteCommand+add);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  SSLBPReadByte := byte(Read32(InterfacePort0+(theaxis*AxisStride)));
  Write32(CSRport+(theaxis*AxisStride),0);
end;

function SSLBPReadLong(theaxis : byte;add : word) : longint;
begin
  Write32(CSRPort+(theaxis*AxisStride),ReadLongCommand+add);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  SSLBPReadLong := Read32(InterfacePort0+(theaxis*AxisStride));
  Write32(CSRport+(theaxis*AxisStride),0);
end;

function SSLBPReadDouble(theaxis : byte;add : word) : comp;
var bigdata : comp;
datal,datah : longint;
begin
  Write32(CSRPort+(theaxis*AxisStride),ReadDoubleCommand+add);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  DoubleLongRec(BigData).Long0 := Read32(InterfacePort0+(theaxis*AxisStride));
  DoubleLongRec(BigData).Long1 := Read32(InterfacePort1+(theaxis*AxisStride));
  SSLBPReadDouble := bigdata;
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure SSLBPWriteLBP(theaxis : byte;cmd : byte; data : byte);
var acommand : longint;
begin
  LongIntByteRec(acommand).Byte3 := LBPWRITE_byte+cmd;
  LongIntByteRec(acommand).Byte2 := 0;
  LongIntByteRec(acommand).Byte1 := 0;
  LongIntByteRec(acommand).Byte0 := 0;
  Write32(CSRPort+(theaxis*AxisStride),acommand);
  Write32(InterfacePort0+(theaxis*AxisStride),data);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure SSLBPWriteByte(theaxis : byte;add : word; data : byte);
begin
  Write32(CSRPort+(theaxis*AxisStride),WriteByteCommand+add);
  Write32(InterfacePort0+(theaxis*AxisStride),data);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure SSLBPWriteWord(theaxis : byte;add : word; data : word);
begin
  Write32(CSRPort+(theaxis*AxisStride),WriteWordCommand+add);
  Write32(InterfacePort0+(theaxis*AxisStride),data);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure SSLBPWriteLong(theaxis : byte;add : word; data: longint);
begin
  Write32(CSRPort+(theaxis*AxisStride),WriteLongCommand+add);
  Write32(InterfacePort0+(theaxis*AxisStride),data);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure SSLBPWriteDouble(theaxis : byte;add : word; data: comp);
begin
  Write32(CSRPort+(theaxis*AxisStride),WriteDoubleCommand+add);
  Write32(InterfacePort0+(theaxis*AxisStride),DoubleLongRec(data).Long0);
  Write32(InterfacePort1+(theaxis*AxisStride),DoubleLongRec(data).Long1);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure SSLBPWriteEEPROMLong(theaxis : byte;add : word;data : longint);
var old : byte;
begin
  {SSLBPDump(Axis);}
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  SSLBPWriteLong(theaxis,add,data);
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
  { test for old }
  old := SSLBPReadLBP(theaxis,LBPNONVOL_flag);
  if old <> 0 then
  begin
    writeln('Old buggy bit file in use');
    delay(100);
    SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
    old := SSLBPReadLBP(theaxis,LBPNONVOL_flag);
    if old <> 0 then
    begin
      writeln('Broken Old buggy bit file in use cycle 8I20 power');
      halt(2);
    end;
  end;
end;

procedure SSLBPWriteEEPROMWord(theaxis : byte;add : word;data : word);
var old : byte;
begin
  {SSLBPDump(Axis);}
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  SSLBPWriteWord(theaxis,add,data);
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
  { test for old }
  old := SSLBPReadLBP(theaxis,LBPNONVOL_flag);
  if old <> 0 then
  begin
    writeln('Old buggy bit file in use');
    delay(100);
    SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
    old := SSLBPReadLBP(theaxis,LBPNONVOL_flag);
    if old <> 0 then
    begin
      writeln('Broken Old buggy bit file in use cycle 8I20 power');
      halt(2);
    end;
  end;
end;

procedure SSLBPWriteEEPROMByte(theaxis : byte;add : word;data : byte);
var old : byte;
begin
  {SSLBPDump(Axis);}
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  SSLBPWriteByte(theaxis,add,data);
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
  { test for old }
  old := SSLBPReadLBP(theaxis,LBPNONVOL_flag);
  if old <> 0 then
  begin
    writeln('Old buggy bit file in use');
    delay(100);
    SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
    old := SSLBPReadLBP(theaxis,LBPNONVOL_flag);
    if old <> 0 then
    begin
      writeln('Broken Old buggy bit file in use cycle 8I20 power');
      halt(2);
    end;
  end;
end;

function SSLBPReadEEPROMLong(theaxis : byte;add : word): longint;
var temp : longint;
begin
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  temp := SSLBPReadLong(theaxis,add);
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
  SSLBPReadEEPROMLong := temp;
end;

function SSLBPReadEEPROMWord(theaxis : byte;add : word): word;
begin
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  SSLBPReadEEPROMWord := SSLBPReadWord(theaxis,add);
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
end;

function SSLBPReadEEPROMByte(theaxis : byte;add : word): byte;
begin
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  SSLBPReadEEPROMByte := SSLBPReadByte(theaxis,add);
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
end;
{
function badSSLBPReadLocal(theaxis : byte;cmd : byte) : byte;
var ourcmd : longint;
begin
  ourcmd := cmd;
  ourcmd := ourcmd shl CommandShift;
  Write32(CSRPort+(theaxis*AxisStride),ourcmd);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  SSLBPReadLocal := byte(Read32(InterfacePort0+(theaxis*AxisStride)));
  Write32(CSRport+(theaxis*AxisStride),0);
end;
 }
{
procedure badSSLBPWriteLocal(theaxis : byte;cmd : byte;data : byte);
var ourcmd : longint;
begin
  ourcmd := cmd;
  ourcmd := ourcmd shl commandshift;
  Write32(CSRPort+(theaxis*AxisStride),ourcmd);
  Write32(InterfacePort0+(theaxis*AxisStride),data);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  Write32(CSRport+(theaxis*AxisStride),0);
end;
}
function oldSSLBPReadLocal(theaxis : byte;cmd : byte) : byte;
begin
  { may be broken }
  Write32(CSRPort+(theaxis*AxisStride),cmd);
  if not(AxisDoIt(theaxis)) then Error(SSLBPTransferFailed);
  oldSSLBPReadLocal := byte(Read32(InterfacePort0+(theaxis*AxisStride)));
  Write32(CSRport+(theaxis*AxisStride),0);
end;

procedure WriteSSRAM(add : word; data : byte);
begin
  Write32(OurDataPort,data);
  Write32(CommandPort,RequestBit+WriteBit+add);
  WaitForDone;
end;

function ReadSSRAM(add : word):  byte;
var
d : byte;
begin
  Write32(CommandPort,RequestBit+add);
  WaitForDone;
  d := Read32(OurDataPort);
  ReadSSRAM := d;
  end;

function ReadSSRAMWord(add : word):  word;
var
d : word;
begin
  Write32(CommandPort,RequestBit+add+0);
  WaitForDone;
  WordRec(d).LowByte := Read32(OurDataPort);
  Write32(CommandPort,RequestBit+add+1);
  WaitForDone;
  WordRec(d).HighByte := Read32(OurDataPort);
  ReadSSRAMWord := d;
end;

function ReadSSRAMLong(add : word):  longint;
var
d : longint;
begin
  LongIntByteRec(d).Byte0 := ReadSSRam(add+0);
  LongIntByteRec(d).Byte1 := ReadSSRam(add+1);
  LongIntByteRec(d).Byte2 := ReadSSRam(add+2);
  LongIntByteRec(d).Byte3 := ReadSSRam(add+3);
  ReadSSRAMLong := d;
end;

function ReadChanSSRAM(chan : byte; add : word):  byte;
begin
  ReadChanSSRAM := ReadSSRAM((chan*SSLBPChannelStride)+SSLBPChannelStart+add);
end;

function ReadChanSSRAMWord(chan : byte; add : word):  word;
begin
  ReadChanSSRAMWord := ReadSSRAMWord((chan*SSLBPChannelStride)+SSLBPChannelStart+add);
end;

function ReadChanSSRAMLong(chan : byte; add : word):  longint;
begin
  ReadChanSSRAMLong := ReadSSRAMLong((chan*SSLBPChannelStride)+SSLBPChannelStart+add);
end;

procedure SSLBPSetNoCRC(theaxis : byte;crc : byte);
begin
  WriteSSRAM((theaxis*SSLBPChannelStride)+SSLBPChannelStart+ChanDisableCRCOffset+0,crc);
 { SSLBPStopAll;}
end;

procedure SSLBPSetBaud(theaxis : byte;baud : longint);
begin
  WriteSSRAM((theaxis*SSLBPChannelStride)+SSLBPChannelStart+ChanBaudRateOffset+0,LongIntByteRec(baud).Byte0);
  WriteSSRAM((theaxis*SSLBPChannelStride)+SSLBPChannelStart+ChanBaudRateOffset+1,LongIntByteRec(baud).Byte1);
  WriteSSRAM((theaxis*SSLBPChannelStride)+SSLBPChannelStart+ChanBaudRateOffset+2,LongIntByteRec(baud).Byte2);
  WriteSSRAM((theaxis*SSLBPChannelStride)+SSLBPChannelStart+ChanBaudRateOffset+3,LongIntByteRec(baud).Byte3);
  SSLBPStopAll;
end;

function SSLBPGetBaud(theaxis : byte) : longint;
begin
  SSLBPGetBaud := ReadChanSSRAMLong(theaxis,ChanBaudRateOffset);
end;


function InitializeSSBaseAddr : boolean;
var
base : word;
nregs : byte;
begin
  InitializeSSBaseAddr := GetModuleInfo(SSerialTag,base,nregs);
  base := base + SSerial * $40;
  CommandPort    := base+$000;
  OurDataPort    := base+$100;
  CSRPort        := base+$200;
  InterfacePort0 := base+$300;
  InterfacePort1 := base+$400;
  InterfacePort2 := base+$500;
  NumberOfBases := nregs;
{  hexprint(base,4);
  writeln('  regs  ',nregs);}
end;

function SSLBPReadCookie(axis : byte) : byte;
begin
  SSLBPReadCookie := SSLBPReadLBP(axis,LBPREADCOOKIE_byte);
end;

function SSLBPProgSync(theaxis : byte): boolean;
var ok : boolean;
cookie : byte;
begin
  cookie := SSLBPReadCookie(theaxis);
  ok := cookie = LBPCOOKIECODE_byte;
  SSLBPProgSync := ok;
end;

procedure SSLBPCommitErase(theaxis : byte);
begin
  SSLBPWriteByte(theaxis,LBPFLASHCOMMIT_ptr,LBPFLASHERASE_byte);
  if not SSLBPProgSync(axis) then BumOut('Sync error');
end;

procedure SSLBPCommitWrite(theaxis : byte);
begin
  SSLBPWriteByte(theaxis,LBPFLASHCOMMIT_ptr,LBPFLASHWRITE_byte);
  if not SSLBPProgSync(axis) then BumOut('Sync error');
end;

procedure SSLBPFlashStart(theaxis : byte);
begin
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,LBPNONVOLFLASH_byte);
end;

procedure SSLBPFlashStop(theaxis : byte);
begin
  SSLBPWriteLBP(theaxis,LBPNONVOL_flag,0);
end;

function SSLBPGetWriteSize(theaxis : byte) : word;
begin
  SSLBPGetWriteSize := 1 shl SSLBPReadByte(theaxis,LBPFLASHWRITESIZE_ptr);
end;

function SSLBPGetEraseSize(theaxis : byte) : word;
begin
  SSLBPGetEraseSize := 1 shl SSLBPReadByte(theaxis,LBPFLASHERASESIZE_ptr);
end;

procedure SSLBPSetOffset(theaxis : byte;off : longint);
begin
  SSLBPWriteLong(theaxis,LBPFLASHOFFSET_ptr,off);
end;

function SSLBPGetOffset(theaxis : byte) :  longint;
begin
  SSLBPGetOffset := SSLBPReadLong(theaxis,LBPFLASHOFFSET_ptr);
end;

procedure SSLBPChannelAccessInit;
begin
  SSLBPMajorRevision := ReadSSRAM(SSLBPMajorRevisionLoc);
  SSLBPMinorRevision := ReadSSRAM(SSLBPMinorRevisionLoc);
  SSLBPChannelStart  := ReadSSRAM(SSLBPChannelStartLoc);
  SSLBPChannelStride := ReadSSRAM(SSLBPChannelStrideLoc);
end;


(*
procedure SSLBPWriteBlock(theaxis,add:word; ourbuffer : BBufPtrType);
var ourdouble : comp;
begin
  DoubleByteRec(ourdouble).Byte0 := (ourbuffer^[0]);
  DoubleByteRec(ourdouble).Byte1 := (ourbuffer^[1]);
  DoubleByteRec(ourdouble).Byte2 := (ourbuffer^[2]);
  DoubleByteRec(ourdouble).Byte3 := (ourbuffer^[3]);
  DoubleByteRec(ourdouble).Byte4 := (ourbuffer^[4]);
  DoubleByteRec(ourdouble).Byte5 := (ourbuffer^[5]);
  DoubleByteRec(ourdouble).Byte6 := (ourbuffer^[6]);
  DoubleByteRec(ourdouble).Byte7 := (ourbuffer^[7]);
  SSLBPWriteDouble(theaxis,add,ourdouble);
end;

procedure SSLBPReadBlock(theaxis,add:word; ourbuffer : RBufPtrType);
var data : comp;
begin
  data := SSLBPReadDouble(theaxis,add);
  ourbuffer^[0] := CompByteRec(data).Byte0;
  ourbuffer^[1] := CompByteRec(data).Byte1;
  ourbuffer^[2] := CompByteRec(data).Byte2;
  ourbuffer^[3] := CompByteRec(data).Byte3;
  ourbuffer^[4] := CompByteRec(data).Byte4;
  ourbuffer^[5] := CompByteRec(data).Byte5;
  ourbuffer^[6] := CompByteRec(data).Byte6;
  ourbuffer^[7] := CompByteRec(data).Byte7;
end;
  *)
{ENDIF}
{ added clearing of CSRPort after each write}
{ added flash support }
