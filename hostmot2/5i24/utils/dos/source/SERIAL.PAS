{ low level 16C450 + 16C550 type serial port routines }

const
Com1       =$03F8;
Com2       =$02F8;
Com3       =$03E8;
Com4       =$02E8;
RecReg     =$00;
TrHReg     =$00;
DivLatLSB  =$00;
DivLatMSB  =$01;
IntEn      =$01;
IntId      =$02;
FIFOCont   =$02;
LineCont   =$03;
ModemCont  =$04;
LineStat   =$05;
ModemStat  =$06;
Scratch    =$07;

StdBRClock = 1.8432E6;         { IBM's dumb rate }
HiBRClock  = 8.0000E6;         { for newer 16C550's }
RealHIBRClock = 2.4000E7;      { for some 16C552's ... Wheee! }
DoubleBRClock = 3.6864E6;
QuadBRClock = DoubleBRClock*2;

{ Line control register stuff }
WLen5      =$00;
WLen6      =$01;
WLen7      =$02;
WLen8      =$03;
StopBits   =$04;
ParityEn   =$08;
EvenParity =$10;
StickParity=$20;
SetBreak   =$40;
DLAB       =$80;
NoDLAB     =$7F;

DefaultLCR = 0 or WLen8;

{ Line status register stuff }
DataReady  =$01;
OverRunErr =$02;
ParityErr  =$04;
FrameErr   =$08;
BreakInt   =$10;
THRE       =$20;
TSRE       =$40;

{ Interrupt ID register stuff }

{ read masks }
IntPending  =$01;
RecChar     =$04;
XmitRdy     =$02;
RecErr      =$06;

{ FIFO control register stuff }

FIFOEnable     =$01;
RecvFIFORst    =$02;
XmitFIFORst    =$04;
DMAMode        =$08;
RecvTrig1      =$00;
RecvTrig4      =$40;
RecvTrig8      =$80;
RecvTrig14     =$C0;
FIFOsOn        =$C0;

{ Interrupt enable register stuff }

DAvIntEn    =$01;
TXRdyIntEn  =$02;
RXErrIntEn  =$04;
LineChIntEn =$08;

DefaultIER = 0;

{ Modem control register stuff }
DTRBit      =$01;
RTSBit      =$02;
Out1Bit     =$04;
Out2Bit     =$08;
LoopBack    =$10;

defaultMCR = 0 or DTRBit or RTSBit or Out1Bit;

{ Modem status register stuff }
DelCTS      =$01;
DelDSR      =$02;
DelRI       =$04;
DelCD       =$08;
CTSBit      =$10;
DSRBit      =$20;
RIBit       =$40;
CDBit       =$80;

type

PortType  =(CP8250,CP16450,CP16550);

SerialSetupType = record
  BaudRate : real;
  IntEnImage : byte;
  LineContImage : byte;
  ModemContImage : byte;
end;

FifteenCharFIFO = record
  PutPointer : word;
  GetPointer : word;
  DataBuffer  : array [0..15] of byte;
  ErrorBuffer : array [0..15] of byte;
end;


function BRDivisorFromBaud(BRC : real;baudrate : longint) : word;
begin
  BRDivisorFromBaud := word(trunc(STDBRClock/(baudrate*16)+0.5));
end;

procedure SetBRDivisor(comPort : word; divisor : word);
var
portSave : byte;
begin
  portSave := port[comPort + LineCont];
  port[comPort + LineCont] := portSave or DLAB;
  port[comPort + DivLatLSB] := lo(divisor);
  port[comPort + DivLatMSB] := hi(divisor);
  port[comPort + LineCont] := portSave and NoDLAB;
end;

procedure GetBRDivisor(comPort : word; var divisor : word);
var
portSave : byte;
begin
  portSave := port[comPort + LineCont];
  port[comPort + LineCont] := portSave or DLAB;
  divisor := port[comPort + DivLatLSB];
  divisor := divisor or (port[comPort + DivLatMSB] * $0100);
  port[comPort + LineCont] := portSave and NoDLAB;
end;


procedure  SetOptBaudRate(comPort : word; baudRate : real; brclock : real);
var
divisor : word;
begin
  divisor := word(trunc((brclock/baudRate)/16 + 0.5));
  SetBRDivisor(comPort,divisor);
end;

procedure  SetBaudRate(comPort : word; baudRate : real);
begin
  SetOptBaudRate(comport,baudrate,StdBRClock);
end;

procedure EnableIntDriver(comPort : word);
var
portSave : word;

begin
  portSave := port[comPort + ModemCont];
  port[comPort + ModemCont] := portSave or Out2Bit;
end;

procedure DisableIntDriver(comPort : word);
var
portSave : word;

begin
  portSave := port[comPort + ModemCont];
  port[comPort + ModemCont] := portSave and ($FF xor Out2Bit);
end;

procedure ForceDTRLow(comPort : word);
var dtemp : byte;
begin
  dtemp := port[comPort + ModemCont];
  port[comPort + ModemCont] :=  dtemp and ($FF xor DTRBit);
end;

procedure ForceDTRHigh(comPort : word);
var dtemp : byte;
begin
  dtemp := port[comPort + ModemCont];
  port[comPort + ModemCont] := (dtemp or DTRBit);
end;

procedure ForceRTSLow(comPort : word);
var dtemp : byte;
begin
  dtemp := port[comPort + ModemCont];
  port[comPort + ModemCont] :=  dtemp and ($FF xor RTSBit);
end;

procedure ForceRTSHigh(comPort : word);
var dtemp : byte;
begin
  dtemp := port[comPort + ModemCont];
  port[comPort + ModemCont] := (dtemp or RTSBit);
end;

procedure ForceOut1Low(comPort : word);
var dtemp : byte;
begin
  dtemp := port[comPort + ModemCont];
  port[comPort + ModemCont] :=  dtemp and ($FF xor Out1Bit);
end;

procedure ForceOut1High(comPort : word);
var dtemp : byte;
begin
  dtemp := port[comPort + ModemCont];
  port[comPort + ModemCont] := (dtemp or Out1Bit);
end;

procedure EnableFIFOs(comport : word);
begin
  port[comPort + FIFOCont] := (FIFOEnable or RecvTrig8);
end;

procedure DisableFIFOs(comport : word);
begin
  port[comPort + FIFOCont] := 0;
end;

{ These 6I23 routines assume that the card jumpering is set }
{ for software enabled RS485 drive with power-up off drive enable polarity}

procedure DriveOn6I23(comPort: word);
begin
  ForceOut1Low(comPort);
end;

procedure DriveOff6I23(comPort: word);
begin
  ForceOut1High(comPort);
end;

{ These 4I23 routines assume that the card jumpering is set }
{ for software enabled RS485 drive with power-up off drive enable polarity}

procedure DriveOn4I23(comPort: word);
begin
  ForceRTSHigh(comPort);
end;

procedure DriveOff4I23(comPort: word);
begin
  ForceRTSLow(comPort);
end;


procedure PolledGetComChar(comPort : word; var cchar : char);
begin
  while (port[comPort + LineStat] and DataReady) = 0 do {wait for rec char} ;
  cchar := char(port[comPort + RecReg]);
end;

function PolledGetComCharWithTimeout(comPort : word; var cchar : char; ctimeout : longint) : longint;
begin
  while ((port[comPort + LineStat] and DataReady) = 0)
  and (ctimeout <> 0) do ctimeout := ctimeout -1;
  {wait for rec char} ;
  if ctimeout <> 0 then cchar := char(port[comPort + RecReg]);
  PolledGetComCharWithTimeout := ctimeout;
end;

procedure TossChars(comPort : word;n: byte);
var count : byte;
thechar : char;
begin
  {old for count := 1 to n do thechar := port[comPort+RecReg]; }
  for count := 1 to n do PolledGetComCharWithTimeout(comPort,thechar,100); { for 4i63 }
end;

procedure DefaultComInit(comPort : word);
begin
  DisableIntDriver(comPort);
  port[comPort + LineCont]  := DefaultLCR;
  port[comPort + IntEn]     := DefaultIER;
  port[comPort + ModemCont] := DefaultMCR;
  TossChars(comPort,18);
  { make real sure there are no pending chars }
end;

function SKeyPressed : boolean;
var flag : boolean;
begin
  asm
    mov ah,01
    int $16
    mov flag,false
    jz @nokey
    mov flag,true
    @nokey:
  end;
  SKeyPressed := flag;
end;

function CTSHighQ(comport : word): boolean;
begin
  if port[comport +ModemStat] and CTSBit = 0 then CTSHighQ := false else CTSHighQ := true;
end;

procedure WaitForCTSHigh(comport : word);
begin
  while not CTSHighQ(comport) do;
end;

procedure WaitForCTSHighWithTimeout(comport : word;var timeout : longint);
var loops : longint;
begin
  loops := 0;
  while not CTSHighQ(comport) and (loops < timeout) do loops := loops +1;
  timeout := loops;
end;

function PolledGetComCharWithKeyAbort(comPort : word; var cchar : char): boolean;
begin
  while ((port[comPort + LineStat] and DataReady) = 0)
  and (not SKeyPressed) do ;
  { wait for rec char or key pressed }
  if not SKeyPressed then
  begin
    cchar := char(port[comPort + RecReg]);
    PolledGetComCharWithKeyAbort := false;
  end
  else
  begin
    PolledGetComCharWithKeyAbort := true;
  end;
end;

procedure PolledPutComChar(comPort : word; cchar : char);
begin
  while (port[comPort + LineStat] and THRE) = 0 do {wait for xmit char} ;
  port[comPort + TrHReg] := byte(cchar);
end;

procedure WaitForXmitDone(comport : word);
begin
  while (port[comPort + LineStat] and (TSRE or THRE)) = 0 do {wait for all xmit chars to be gone };
end;


procedure Polled485PutComChar(comPort : word; cchar : char);
begin
  ForceRTSHigh(comPort);
  while (port[comPort + LineStat] and THRE) = 0 do {wait for xmit char} ;
  port[comPort + TrHReg] := byte(cchar);
  WaitForXmitDone(comPort);
  ForceRTSLow(comPort);
end;

procedure PolledPutComCharWithHandshake(comPort : word; cchar : char);
begin
  while ((port[comPort + ModemStat] and CTSBit) = 0)
  and (not SKeyPressed) do ;
  { wait for cts or key pressed }
  if not SKeyPressed then
  begin
    port[comPort + TrHReg] := byte(cchar); {write the char}
    while (port[comPort + LineStat] and TSRE) = 0 do {wait for xmit char} ;
  end;
end;

procedure PolledPutComCharWithCTSHandshakeAndTimeout(comPort : word; cchar : char; timeout : longint);
begin
  WaitForCTSHighWithTimeout(comPort,timeout);
  begin
    port[comPort + TrHReg] := byte(cchar); {write the char}
    while (port[comPort + LineStat] and TSRE) = 0 do {wait for xmit char} ;
  end;
end;

procedure PutOneComChar(comPort : word; cchar : char);
begin
  port[comPort + TrHReg] := byte(cchar);
  WaitForXmitDone(comport);
end;

procedure SetUpForRecInt(comPort : word);
var loop,temp : byte;
begin
  port[comPort + IntEn] := DAvIntEn or RxErrIntEn;
  for loop := 0 to 15 do
  begin
    temp := port[comPort + RecReg];
    temp := port[comPort + LineStat];
    temp := port[comPort + IntId];
    temp := port[comPort + ModemStat];
  end;
  EnableIntDriver(comPort);
end;

procedure SetUpForXmitInt(comPort : word);
var loop,temp : byte;
begin
  EnableIntDriver(comPort);
  for loop := 0 to 15 do
  port[comPort + IntEn] := TXRdyIntEn;
  begin
    temp := port[comPort + IntId];
    temp := port[comPort + RecReg];
    temp := port[comPort + LineStat];
    temp := port[comPort + ModemStat];
  end;
end;

procedure ForceIRQLow(comPort : word);
begin
  EnableIntDriver(comPort);
  port[comPort + IntEn] := 0;
end;

{**** Software FIFO stuff for int driven examples ****}

procedure InitFIFO(fifo : FifteenCharFIFO);
begin
  with fifo do
  begin
    PutPointer := 0;
    GetPointer := 0;
  end;
end;

function FIFOHasData(fifo : FifteenCharFIFO): boolean;
begin
  FIFOHasData := false;
  with fifo do
  begin
    if GetPointer <> PutPointer then FIFOHasData := true;
  end;
end;

function FIFOIsFull(fifo : FifteenCharFIFO): boolean;
begin
  FIFOIsFull := false;
  with fifo do
  begin
    { if hypothetical put put would smash get data then fifo is full! }
    { + 2 is to avoid empty=full case (and why its only 15 chars long }
    if ((PutPointer + 2) and $0F)  = GetPointer then FIFOIsFull := true;
  end;
end;

function FIFOGet(fifo : FifteenCharFIFO) : word;
begin
  if FIFOHasData(fifo) then
  begin
    with fifo do
    begin
      FIFOGet := DataBuffer[GetPointer] or (ErrorBuffer[GetPointer] * 256);
      GetPointer := (GetPointer +1) and $0F;
    end;
  end;
end;

procedure FIFOPut(fifo : FifteenCharFIFO;data :word);
begin
  if not FIFOIsFull(fifo) then
  begin
    with fifo do
    begin
      DataBuffer[PutPointer]  := byte(data);
      ErrorBuffer[PutPointer] := byte(data shr 8);
      PutPointer := (PutPointer +1) and $0F;
    end;
  end;
end;

function GetRecIntChar(comPort : word;var achar : char) : boolean;
var
temp : byte;
begin
  temp := port[comPort+IntId];
  if temp and $7 = 4 then { valid rec char or FIFO timeout on '550 }
  begin
    achar := char(port[comPort + RecReg]);
    GetRecIntChar := true;
  end
  else
  begin
    temp := port[comPort +LineStat];
    GetRecIntChar := false;
  end;
  port[comPort + IntEn] := 0;                  { make sure we generate a new IRQ edge }
  port[comPort + IntEn] := DAvIntEn or RxErrIntEn;     { by disabling then re-enabling the IRQ }
end;

function COMPortThere(comport : word) : boolean;
var
tdata : byte;
bdata : word;
olddivisor :word;
begin
  GetBRDivisor(comport,olddivisor);
  COMPortThere := true;
  { used to start at 0 but Exar UARTs wont allow 0 in divisor reg }
  for tdata := 1 to 100 do
  begin
    SetBRDivisor(comport,tdata*631);
    GetBRDivisor(comport,bdata);
    if bdata <> (tdata * 631) then ComPortThere := false;
  end;
  SetBRDivisor(comport,olddivisor);
end;

function CarefulCOMPortThere(comport : word) : boolean;
var
tdata : byte;
bdata : word;
olddivisor :word;
oldscratch : byte;
begin
  CarefulComPortThere := false;
  oldscratch := port[comport + $07];
  port[comport+$07] := $55;
  tdata := port[comport +$07];
  port[comport+$07] := (tdata xor $FF);
  if tdata = $AA then
  begin
    GetBRDivisor(comport,olddivisor);
    CarefulCOMPortThere := true;
    { used to start at 0 but Exar UARTs wont allow 0 in divisor reg }
    for tdata := 1 to 100 do
    begin
      SetBRDivisor(comport,tdata*631);
      GetBRDivisor(comport,bdata);
      if bdata <> (tdata * 631) then CarefulComPortThere := false;
    end;
    SetBRDivisor(comport,olddivisor);
  end;
  port[comport + $0F] := oldscratch

end;

function COMPortType(comport : word) : PortType;
var
tdata : byte;
thetype : PortType;
begin
  thetype := CP16450;
  for tdata := 0 to 255 do
  begin
    port[comport+Scratch] := tdata;
    port[comport+ModemStat] := $FF xor tdata;
    if port[comport + Scratch] <> tdata then thetype := CP8250;
  end;
  if thetype <> CP8250 then
  begin
    port[comport+FIFOCont] := 0;
    if (port[comport+FIFOCont] and FIFOsOn) = 0 then
    begin
      port[comport+FIFOCont] := FIFOEnable;
      if (port[comport+FIFOCont] and FIFOsOn) <> 0 then thetype := CP16550;
      port[comport+FIFOCont] := 0;
    end;
  end;
  COMPortType := thetype;
end;

procedure PrintComPortType(comport : word);
begin
  writeln;
  case ComPortType(comport) of
    CP8250  : writeln('COM port type is 8250');
    CP16450 : writeln('COM port type is 16450');
    CP16550 : writeln('COM port type is 16550');
  end;
end;

