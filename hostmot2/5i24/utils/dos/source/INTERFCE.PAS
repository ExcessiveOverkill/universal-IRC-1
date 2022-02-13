{ interface }

const
MaxParserTimeout                = 25;   { milliseconds }

CharTimeoutErr                  = 1;
CharDataErr                     = 2;
TimeoutIRBFIFONotEmpty          = 3;
TimeoutICDFIFONotFull           = 4;
TimeoutICDFIFONotHalfFull       = 5;
TimeoutQRBFIFONotEmpty          = 6;
TimeoutQCDFIFONotFull           = 7;
TimeoutQCDFIFONotHalfFull       = 8;
TimeoutQRBFIFOHalfFull          = 9;
TimeOutIRBFIFOHalfFull          = 10;
SSLBPTransferFailed             = 11;
LastError                       = 12;
type

errrec =
record
  errnum : integer;
  errstr :string[50];
end;

const
errorrecord : array[1 .. LastError] of errrec =
  (
  (errnum : CharTimeoutErr;            errstr : 'Time out waiting for Character'),
  (errnum : CharDataErr;               errstr : 'Character Data Error'),
  (errnum : TimeoutIRBFIFONotEmpty;    errstr : 'Time out waiting for IRB FIFO not empty'),
  (errnum : TimeoutICDFIFONotFull;     errstr : 'Time out waiting for ICD FIFO not full'),
  (errnum : TimeoutICDFIFONotHalfFull; errstr : 'Time out waiting for ICD FIFO not half full'),
  (errnum : TimeoutQRBFIFONotEmpty;    errstr : 'Time out waiting for QRB FIFO not empty'),
  (errnum : TimeoutQCDFIFONotFull;     errstr : 'Time out waiting for QCD FIFO not full'),
  (errnum : TimeoutQCDFIFONotHalfFull; errstr : 'Time out waiting for QCD FIFO not half full'),
  (errnum : TimeoutQRBFIFOHalfFull;    errstr : 'Time out waiting for QRB FIFO half full'),
  (errnum : TimeoutIRBFIFOHalfFull;    errstr : 'Time out waiting for IRB FIFO half full'),
  (errnum : SSLBPTransferFailed;       errstr : 'SSLBP Transfer Failed'),
  (errnum : LastError;                 errstr : '')
  );

{$IFNDEF WINDOWS}
procedure DisableInterrupts;
begin
  inline($FA);                                 { CLI }
end;

procedure EnableInterrupts;
begin
  inline($FB);                                 { STI }
end;
{$ENDIF NOT WINDOWS}

const
CharTimeOutSeconds = 1;
PollTimeOutSeconds = 1;
BusTimeOut = 500000*PollTimeOutSeconds;
BitsPerChar = 10;
LoopsPermS = 400;
PollChars = 8;
AxisOffset = 10;
ProcResetBit : word = $8000;
LongFlag : word = $2000;
WaitTokenFlag : word = $4000;
DoubleFlag : word = $6000;
WriteFlag : word = $8000;
BlockFlag : word = $C000;
ROMSize1 = 1024;
ROMSize2 = 2048;
SignatureOffset = -1;
Signature = $CAFE;
DefaultPC104BasePort0 = $220;
DefaultPC104BasePort1 = $230;
DefaultPC104BasePort2 = $240;
DefaultPC104BasePort3 = $250;

DefaultPC104BasePort = DefaultPC104BasePort0;

DefaultLBPBasePort = $80;
DefaultEPPBasePort = $378;

IFIFOPortOffset = 0;
QFIFOPortOffset = 4;
ROMAddOffset =  8;
StatusRegOffset = 8;
ROMDataOffset  = 12;

type
InterfaceTypes = (EPP,PCIMem,PCIPort,ISAPort,OSDevice,ELBP16,OSLBP);
ProtocolTypes = (Bus,Hex,LBP,SSLBP,Direct,Invalid);
Cardtypes =  (PC104,PCI,SevenI60,ThreeC20,SevenI43,EightC20);
ParamArray = array[1..1024] of word;
SerTypes = (Normal,TwoWire);

var
Axis : byte;
TheInterface : InterfaceTypes;
Protocol : ProtocolTypes;
CardType : cardtypes;
PC104Port,PCIPortAddr : word;
PCIMaddr : longint;
IFIFOPort : word;
QFIFOPort : word;
ROMAddPort : word;
StatusPort : word;
ROMDataPort : word;
PollTimeOut : longint;
SerType : SerTypes;
dummybyte : byte;
dummyword : word;
Message : string;
TempBaudRate: longint;

procedure Error(err : integer); forward;

{$I parsep}
{$I hread.pas}
{$I hprint.pas}
{$I DataRec}
{$I LBP.pas}

procedure BumOut(es : string);
begin
  writeln;
  writeln(es);
{  forceRTSLow(Thecomport); this needs a DOS and windows procedure }
  halt(2);
end;


{$IFNDEF WINDOWS}

procedure FLAT_install; external;
procedure FLAT_destall; external;

procedure WriteMem32(add,data : longint);
var
datahigh,datalow,addhigh,addlow: word;

begin
  datahigh := longintrec(data).HighWord;
  datalow := longintrec(data).LowWord;
  addhigh := longintrec(add).HighWord;
  addlow  := longintrec(add).LowWord;
  asm
    push ds
    db $66,$33,$c0      { xor eax,eax }
    db $66,$8e,$d8      { mov ds,eax }
    mov cx,addhigh
    db $66,$c1,$e1,$10  {shl ecx 16}
    mov cx,addlow
    mov ax,datahigh
    db $66,$c1,$e0,$10  {shl eax,16}
    mov ax,datalow
    db $3e              { ds: }
    db $67,$66,$89,$01  { mov [ecx],eax write data to address}
    pop ds
  end;
end;

procedure ReadMem32(add : longint;var data : longint);
var
datahigh,datalow,addhigh,addlow: word;

begin
  addhigh := longintrec(add).HighWord;
  addlow  := longintrec(add).LowWord;
  asm
    push ds
    db $66,$33,$c0      { xor eax,eax }
    db $66,$8e,$d8      { mov ds,eax }
    mov cx,addhigh
    db $66,$c1,$e1,$10  {shl ecx 16}
    mov cx,addlow
    db $3e              { ds: }
    db $67,$66,$8b,$01  { mov eax,[ecx]   get data}
    mov datalow,ax
    db $66,$c1,$e8,$10  {shr eax,16}
    mov datahigh,ax
    pop ds
  end;
  LongIntRec(data).LowWord := datalow;
  LongIntRec(data).HighWord := datahigh;
end;



procedure ELBP16WriteHM2(addr:word;data:longint);
begin
end;

function ELBP16ReadHM2(addr:word) : longint;
begin
  ELBP16ReadHM2 := 0;
end;

procedure OSLBPWriteLong(addr:word;data:longint);
begin
end;

function OSLBPReadLong(addr:word) : longint;
begin
  OSLBPReadLong := 0;
end;

  {$I EPP.pas}
  {$I PCI.pas}
  {$I pcibrid}
  {$L flat.obj}

{$ENDIF}

{$IFDEF WINDOWS}

{DUMMY}
var EPPBasePort : word;

procedure  WriteMem32(addr : longint;data : longint);
begin
end;

procedure FastWriteEPP32(addr: word;data: longint);
begin
end;

function FastReadEPP32(addr:word) : longint;
begin
  FastReadEPP32 := 0;
end;

procedure ReadMem32(addr: longint; var data :longint);
begin
  data := 0;
end;


procedure EPPInit;
begin
end;

procedure ELBP16WriteHM2(addr:word;data:longint);
var sstring : string;
begin
  sstring := '';
  sstring := sstring + char($01);  { one}
  sstring := sstring + char($C2);  { write doubleword }
  sstring := sstring + char(wordrec(addr).LowByte);
  sstring := sstring + char(wordrec(addr).HighByte);
  sstring := sstring + char(LongIntByteRec(data).Byte0);
  sstring := sstring + char(LongIntByteRec(data).Byte1);
  sstring := sstring + char(LongIntByteRec(data).Byte2);
  sstring := sstring + char(LongIntByteRec(data).Byte3);
  Socket.SendString(sstring);
end;

function ELBP16ReadHM2(addr:word) : longint;
var
sstring,rstring : string;
rd : longint;
begin
  sstring := '';
  sstring := sstring + char($01);  { one}
  sstring := sstring + char($42);  { read doubleword }
  sstring := sstring + char(wordrec(addr).LowByte);
  sstring := sstring + char(wordrec(addr).HighByte);
  Socket.SendString(sstring);
  rstring := Socket.RecvPacket(1000);
  if Socket.LastError <> 0 then Bumout(Socket.LastErrorDesc);
  LongIntByteRec(rd).Byte0 := byte(rstring[1]);
  LongIntByteRec(rd).Byte1 := byte(rstring[2]);
  LongIntByteRec(rd).Byte2 := byte(rstring[3]);
  LongIntByteRec(rd).Byte3 := byte(rstring[4]);
  ELBP16ReadHM2 := rd;
end;

function LBPReadLong(add: word) : longint; forward;

procedure LBPWriteLong(add: word; data: longint); forward;

procedure OSLBPWriteLong(addr: word;data: longint);
begin
  LBPWriteLong(addr,data);
end;


function OSLBPReadLong(addr: word) : longint;
begin
  OSLBPReadLong := LBPReadLong(addr);
end;


{$ENDIF}


procedure Write32(addr : word; data : longint);
begin
  case TheInterface of
    EPP : FastWriteEPP32(addr,data);
    PCIMEM : WriteMem32(PCIMaddr+addr,data);
    ELBP16 : ELBP16WriteHM2(addr,data);
    OSLBP : OSLBPWriteLong(addr,data);
  end;
end;

function Read32(addr : word) : longint;
var thedata : longint;
begin
  case TheInterface of
    EPP : Read32 := FastReadEPP32(addr);
    PCIMEM :
    begin
      ReadMem32(PCIMaddr+addr,thedata);
      Read32 := thedata;
    end;
    ELBP16 : Read32 := ELBP16ReadHM2(addr);
    OSLBP : Read32 := OSLBPReadLong(addr);
  end;
end;

{$I HM2LOW.pas}
{$I Userial}
{$I ULBPLow.pas}
{$I sercmds4}
{$I SSLBPLow.pas}


function ReadCardName(axis : byte): string;
begin
  case protocol of
    LBP: ReadCardName := LBPReadCardName;
    SSLBP: ReadCardName := SSLBPReadCardName(axis);
    else BumOut('Invalid protocol');
  end;
end;

function ReadCookie(axis : byte): byte;
begin
  case protocol of
    LBP: ReadCookie := LBPReadCookie;
    SSLBP: ReadCookie := SSLBPReadCookie(axis);
    else BumOut('Invalid protocol');
  end;
end;

function ProgSync(axis : byte) : boolean;
begin
  case protocol of
    LBP: ProgSync := LBPProgSync;
    SSLBP: ProgSync := SSLBPProgSync(axis);
    else BumOut('Invalid protocol');
  end;
end;

procedure CommitErase(axis : byte);
begin
  case protocol of
    LBP: LBPCommitErase;
    SSLBP: SSLBPCommitErase(axis);
    else BumOut('Invalid protocol');
  end;
end;

procedure CommitWrite(axis : byte);
begin
  case protocol of
    LBP: LBPCommitWrite;
    SSLBP: SSLBPCommitWrite(axis);
    else bumout('Invalid protocol');
  end;
end;

procedure FlashStart(axis : byte);
begin
  case protocol of
    LBP: LBPFlashStart;
    SSLBP: SSLBPFlashStart(axis);
    else bumout('Invalid protocol');
  end;
end;

procedure FlashStop(axis : byte);
begin
  case protocol of
    LBP: LBPFlashStop;
    SSLBP: SSLBPFlashStop(axis);
    else bumout('Invalid protocol');
  end;
end;

function GetWriteSize(axis : byte) : word;
begin
  case protocol of
    LBP: GetWriteSize := LBPGetWriteSize;
    SSLBP: GetWriteSize := SSLBPGetWriteSize(axis);
    else bumout('Invalid protocol');
  end;
end;

function GetEraseSize(axis : byte) : word;
begin
  case protocol of
    LBP: GetEraseSize := LBPGetEraseSize;
    SSLBP: GetEraseSize := SSLBPGetEraseSize(axis);
    else bumout('Invalid protocol');
  end;
end;

procedure SetOffset(axis : byte;off : longint);
begin
  case protocol of
    LBP: LBPSetOffset(off);
    SSLBP: SSLBPSetOffset(axis,off);
    else bumout('Invalid protocol');
  end;
end;

function GetOffset(axis : byte) :  longint;
begin
  case protocol of
    LBP: GetOffset := LBPGetOffset;
    SSLBP: GetOffset := SSLBPGetOffset(axis);
    else bumout('Invalid protocol');
  end;
end;

{$IFNDEF WINDOWS}

function KeyPressed : boolean;
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
  KeyPressed := flag;
end;
{$ENDIF}

procedure GetOurEnv;
var
retcode : integer;
Interfacestr,portstr,baudstr,baudmulstr,protostr : string;
pc104Addstr,scomport,sertypestr,ipaddrstr,eppportstr : string;
comnumber,ourcomport : longint;
begin
  PollTimeout := BusTimeOut;

  interfacestr := upstring(GetEnv('INTERFACE'));
  portstr :=      upstring(GetEnv('COMPORT'));
  baudstr :=      upstring(GetEnv('BAUDRATE'));
  baudmulstr :=   upstring(GetEnv('BAUDRATEMUL'));
  ipaddrstr :=    upstring(GetEnv('IPADDR'));
  protostr :=     upstring(GetEnv('PROTOCOL'));
  pc104Addstr :=  upstring(GetEnv('PC104ADD'));
  eppportstr := upstring(GetEnv('EPPPORT'));
  sertypestr :=   upstring(GetEnv('SERTYPE'));
  ComPortHardwareType := NoPort;

  if sertypestr = 'TWOWIRE' then sertype := TwoWire else sertype := Normal;

  if length(Interfacestr) = 0 then BumOut('Interface not in Environment')
  else
  begin
    if Interfacestr = 'EPP' then TheInterface := EPP;
    if Interfacestr = 'PCIMEM' then TheInterface := PCIMem;
    if Interfacestr = 'ISAPORT' then TheInterface := ISAPort;
    if Interfacestr = 'OSDEVICE' then TheInterface := OSDevice;
    if Interfacestr = 'ELBP16' then TheInterface := ELBP16;
    if Interfacestr = 'OSLBP' then TheInterface := OSLBP;
  end;
{$IFDEF WINDOWS}
  if TheInterface = ELBP16 then
  begin
    if not IsIP(ipaddrstr) then BumOut('Ethernet protocol but no IP address');
    IPAddr := ipaddrstr;
  end;

  if TheInterface = OSLBP then
  begin
    if copy(portstr,1,3) = 'COM' then
    begin
      val(copy(portstr,4,length(portstr)),comnumber,retcode);
      if retcode = 0 then scomport := portstr else Bumout('Undecipherable Windows COM port - bail out!');
    end;
  end;
  {$ENDIF}

{$IFNDEF WINDOWS}
  if TheInterface = ELBP16 then
  begin
    BumOut('Ethernet protocols not supported under DOS');
  end;
{$ENDIF}

  Protocol := invalid;
  if length(protostr) = 0 then
  begin
    Writeln('Protocol not in Environment, assuming Hex');
    Protocol := Hex;
  end
  else
  begin
    if protostr = 'BUS' then Protocol := Bus;
    if protostr = 'LBP' then Protocol := LBP;
    if protostr = 'HEX' then Protocol := Hex;
    if protostr = 'SSLBP' then Protocol := SSLBP;
    if protostr = 'DIRECT' then Protocol := DIRECT;
  end;
  case Protocol of
    Direct:
    begin
    end;

    Bus:
    begin
{$IFNDEF WINDOWS}
      Pc104Port := DefaultPC104BasePort;
      if length(pc104addstr) <> 0 then
      if HexWordRead(pc104addstr,Pc104Port) then
      begin
        if (Pc104Port < $220) or (Pc104Port >$250) or (Pc104Port and $000F <> 0) then Bumout('Invalid PC104 address');
      end else Bumout('Can''t parse PC/104 address');
{$ELSE}
      Bumout('Protocol not supported');
{$ENDIF}
    end; {bus}

    SSLBP: ComPortHardwareType := SSLBPPort;

    Hex,LBP: { serial }
    begin
      ComPortHardwareType := STDComPort; { default }

      if length(portstr) = 0 then
      begin
        Writeln('Comport not in Environment, assuming COM1');
        portstr := 'COM1';
      end;
      { now parse comport }
{$IFDEF WINDOWS}
      if copy(portstr,1,3) = 'COM' then
      begin
        val(copy(portstr,4,length(portstr)),comnumber,retcode);
        if retcode = 0 then scomport := portstr else Bumout('Undecipherable Windows COM port - bail out!');
      end
      else Bumout('Undecipherable Windows COM port - bail out!');
{$ELSE}
      { check for hex address }
      if (HexLongRead(portstr,ourcomport)) then
      begin
        if (ourcomport <$100) or (ourcomport >$FFF8) then Bumout ('Out of range COM port address - bail out!');
        if (ourcomport and 7) <> 0 then Bumout('Illegal COM port address - bail out!');
        ComPortHardwareType := STDComPort{HEXComPort};
      end;

      { check for mesa }
      if copy(portstr,1,4) = 'MCOM' then
      begin
        val(copy(portstr,5,length(portstr)),comnumber,retcode);
        if retcode = 0 then
        begin
           ourcomport := comnumber{-1} { 0 based } ;
           ComPortHardwareType := MESAComPort;
        end else  Bumout('Undecipherable MCOM port');
      end;

      if ComPortHardwareType = STDComPort then
      begin
        ourcomport := 0;
        if portstr = 'COM1' then ourcomport := COM1;
        if portstr = 'COM2' then ourcomport := COM2;
        if portstr = 'COM3' then ourcomport := COM3;
        if portstr = 'COM4' then ourcomport := COM4;
        if ourcomport = 0 then Bumout('Undecipherable COM port - bail out!')
      end; {comporttype }
{$ENDIF}

      if length(baudmulstr) = 0 then
      begin
        Writeln('BaudrateMul not in Environment, assuming 1');
        TheBaudRateMul := 1;
      end else
      begin
        val(baudmulstr,TheBaudRateMul,retcode);
        if (TheBaudRateMul <1) or (TheBaudRateMul >64) or (retcode <> 0) then
        begin
          Bumout('Illegal Baud rate Multiplier - bail out!');
        end;
      end; { baudmulstr }
    end; {hex,lbp}
 end; { protocol }

    if (Protocol = Hex) or (Protocol = LBP) or (Protocol = SSLBP) then { serial }
    begin
      if length(baudstr) = 0 then
      begin
        TheBaudRate := 115200;
        if (Protocol = SSLBP) then TheBaudRate := 2500000;
        Writeln('Baudrate not in Environment, assuming ',TheBaudRate,' Baud');
      end
      else val(baudstr,TheBaudRate,retcode);
    end;

    if TheInterface = EPP then
    begin
      EPPBasePort := DefaultEPPBasePort;
      if length(eppportstr) <> 0 then
      begin
        if HexWordRead(eppportstr,EPPBasePort) then
        begin
          if (EPPBasePort and $0007 <> 0) then Bumout('Invalid EPP address');
        end else Bumout('Can''t parse EPP address');
      end;
    end;

{$IFDEF WINDOWS}
    CharTimeout := CharTimeOutSeconds*1000;
    TheComPort := scomport;
{$ELSE}
    CharTimeout := CharTimeOutSeconds*1000*LoopsPermS;
    TheComPort := word(ourcomport);
{$ENDIF}
end;

{ motlow4 stuff}
function SerReadFifoStatus: word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerReadFifoStatusCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadFifoStatus := data;
end;

{$IFDEF WINDOWS}
  {$IFDEF FIFO}
     var portw :  array [0..65535] of word;
  {$ENDIF FIFO}
{$ENDIF}

{$I serhost4.pas}
{$IFDEF FIFO}
  {$I parhost4.pas}
{$ENDIF FIFO}

{$I uLBPhost.pas}

{$IFDEF FIFO}

procedure WriteRom(add : word;data : word);
begin
   case Protocol of
     Bus:  BusWriteRom(add,data);
    { Hex: HexWriteRom(add,data); }
     LBP:  LBPWriteRom(add,data);
   end;
end;

function ReadRom(add : word): word;
begin
   case Protocol of
     Bus:  ReadRom := BusReadRom(add);
    { Hex: ReadRom(add) := HexReadRom(add);}
     LBP:  ReadRom := LBPReadRom(add);
   end;
end;
{$ENDIF FIFO}


procedure WriteWord(add : word;data : word);
begin
   case Protocol of
     Hex: SerWritePicWord((add*2)+2048,data);
     LBP: LBPWriteWord(add,data);
     SSLBP: SSLBPWriteWord(Axis,add,data);
   end;
end;

procedure WriteByte(add : word;data : byte);
begin
   case Protocol of
   {  Hex: SerWritePicByte((add*2)+2048,data);}
     LBP: LBPWriteByte(add,data);
     SSLBP: SSLBPWriteByte(Axis,add,data);
   end;
end;

function ReadWord(add : word): word;
begin
   case Protocol of
     Hex: ReadWord := SerReadPicWord((add*2)+2048);  { for parameter compatibility }
     LBP: ReadWord := LBPReadWord(add);
     SSLBP: ReadWord := SSLBPReadWord(Axis,add);
   end;
end;

function ReadByte(add : word): byte;
begin
   case Protocol of
     {Hex: ReadByte := SerReadPicByte((add*2)+2048); } { for parameter compatibility }
     LBP: ReadByte := LBPReadByte(add);
     SSLBP: ReadByte := SSLBPReadByte(Axis,add);
   end;
end;

{$IFDEF EEPROM}
procedure WriteEEPROM(add : word;data : byte);
begin
   case Protocol of
     Hex: SerWriteEEPROM(add,data);
     LBP: LBPWriteEEPROM(add,data);
   end;
end;

function ReadEEPROM(add : word): byte;
begin
   case Protocol of
     Hex: ReadEEPROM := SerReadEEPROM(add);
     LBP: ReadEEPROM := LBPReadEEPROM(add);
   end;
end;

procedure WriteEEPROMLong(add : word;data : longint);
begin
   case Protocol of
     {Hex: SerWriteEEPROMLong(add,data);}
     LBP: LBPWriteEEPROMLong(add,data);
     SSLBP: SSLBPWriteEEPROMLong(Axis,add,data);
   end;
end;

function ReadEEPROMLong(add : word): longint;
begin
   case Protocol of
     {Hex:   ReadEEPROMLong := SerReadEEPROMLong(add);}
     LBP:   ReadEEPROMLong := LBPReadEEPROMLong(add);
     SSLBP: ReadEEPROMLong := SSLBPReadEEPROMLong(Axis,add);
   end;
end;

procedure WriteEEPROMWord(add : word;data : word);
begin
   case Protocol of
     Hex: SerWriteEEPROMWord(add,data);
     LBP: LBPWriteEEPROMWord(add,data);
     SSLBP: SSLBPWriteEEPROMWord(Axis,add,data);
   end;
end;

function ReadEEPROMWord(add : word): word;
begin
   case Protocol of
     Hex: ReadEEPROMWord := SerReadEEPROMWord(add);
     LBP: ReadEEPROMWord := LBPReadEEPROMWord(add);
     SSLBP: ReadEEPROMWord := SSLBPReadEEPROMWord(Axis,add);
   end;
end;

procedure WriteEEPROMByte(add : word;data : byte);
begin
   case Protocol of
     Hex: WriteEEPROMByte(add,data);
     LBP: LBPWriteEEPROM(add,data);
     SSLBP: SSLBPWriteEEPROMByte(axis,add,data);
   end;
end;

function ReadEEPROMByte(add : word): byte;
begin
   case Protocol of
     {Hex: ReadEEPROMByte := SerReadEEPROMByte(add);}
     LBP: ReadEEPROMByte := LBPReadEEPROM(add);
     SSLBP: ReadEEPROMByte := SSLBPReadEEPROMByte(Axis,add);
   end;
end;
{$ENDIF EEPROM}

procedure WriteLong(add : word;data : longint);
begin
   case Protocol of
     Hex:
       begin
         SerWritePicWord((add*2)+2048,LongIntRec(data).LowWord);
         SerWritePicWord((add*2)+2048+2,LongIntRec(data).HighWord);
       end;
     LBP: LBPWriteLong(add,data);
     SSLBP: SSLBPWriteLong(Axis,add,data);
   end;
end;

procedure WriteDouble(add : word;data : comp);
begin
   case Protocol of
     Hex:
       begin
         SerWritePicWord((add*2)+2048,DoubleIntRec(data).Word0);
         SerWritePicWord((add*2)+2048+2,DoubleIntRec(data).Word1);
         SerWritePicWord((add*2)+2048+4,DoubleIntRec(data).Word2);
         SerWritePicWord((add*2)+2048+6,DoubleIntRec(data).Word3);
       end;
     LBP: LBPWriteDouble(add,data);
     SSLBP: SSLBPWriteDouble(axis,add,data);
   end;
end;

function ReadLong(add : word): longint;
var rwl,rwh : word;
rl : longint;
begin
   case Protocol of
     Hex:
       begin
         rwl := SerReadPicWord((add*2)+2048);
         rwh := SerReadPicWord((add*2)+2048+2);
         LongIntRec(rl).LowWord := rwl;
         LongIntRec(rl).HighWord := rwh;
         ReadLong := rl;
       end;
     LBP: ReadLong := LBPReadLong(add);
     SSLBP: ReadLong := SSLBPReadLong(Axis,add);
   end;
end;

function ReadDouble(add : word): comp;
var rw0,rw1,rw2,rw3 : word;
rd : comp;
begin
   case Protocol of
     Hex:
       begin
         rw0 := SerReadPicWord((add*2)+2048);
         rw1 := SerReadPicWord((add*2)+2048+2);
         rw2 := SerReadPicWord((add*2)+2048+4);
         rw3 := SerReadPicWord((add*2)+2048+6);
         DoubleIntRec(rd).Word0 := rw0;
         DoubleIntRec(rd).Word1 := rw1;
         DoubleIntRec(rd).Word2 := rw2;
         DoubleIntRec(rd).Word3 := rw3;
         DoubleIntRec(rd).Word0 := rw0;
         ReadDouble := rd;
       end;
     LBP: ReadDouble := LBPReadDouble(add);
     SSLBP: ReadDouble := SSLBPReadDouble(Axis,add);
   end;
end;


{$IFDEF FIFO}
procedure SoftDmcResetOn;
begin
   case Protocol of
     Bus:  BusSoftDMCResetOn;
     Hex: ;
     LBP:  LBPSoftDMCResetOn;
   end;
end;

procedure SoftDmcResetOff;
begin
   case Protocol of
     Bus:  BusSoftDMCResetOff;
     Hex: { WHAT ABOUT 3C20  AND 7I60};
     LBP:  LBPSoftDMCResetOff;
   end;
end;

function ReadFIFOStatus : word;
begin
   case Protocol of
     Bus: ReadFIFOStatus := BusReadFifoStatus;
     Hex: ReadFIFOStatus := SerReadFifoStatus;
     LBP: ReadFIFOStatus := LBPReadFifoStatus;
   end;
end;

procedure WaitForIRBFIFONotEmpty;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and IRE = 0) or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutIRBFIFONotEmpty);
end;

procedure WaitForICDFIFONotFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and IFF = 0) or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutICDFIFONotFull);
end;

procedure WaitForICDFIFONotHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and IFH = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutICDFIFONotHalfFull);
end;

procedure WaitForQRBFIFONotEmpty;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and QRE = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutQRBFIFONotEmpty);
end;

procedure WaitForQCDFIFONotFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and QFF = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutQCDFIFONotFull);
end;

procedure WaitForQCDFIFONotHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and QFH = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutQCDFIFONotHalfFull);
end;

procedure WaitForQRBFIFOHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and QRH <> 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutQRBFIFOHalfFull);
end;

procedure WaitForIRBFIFOHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((ReadFIFOStatus and IRH <> 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeOutIRBFIFOHalfFull);
end;

procedure WriteCommand(theaxis: byte;theparm: word);
var command : word;
{ 16 bit parameter write }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or (theaxis shl AxisOffset));
   case Protocol of
     Bus: BusWriteCommand(command);
     Hex: SerWriteCommand(command);
     LBP: LBPWriteCommand(command);
   end;
end;

procedure WriteCommandQ(theaxis: byte;theparm: word);
var command : word;
{ 16 bit parameter write }
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or (theaxis shl AxisOffset));
   case Protocol of
     Bus: BusWriteCommandQ(command);
     Hex: SerWriteCommandQ(command);
     LBP: LBPWriteCommandQ(command);
   end;
end;

procedure WriteParamWord(theaxis: byte;theparm: word;thedata : word);
var command : word;
{ 16 bit parameter write }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or WriteFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus: BusWriteParamWord(command,thedata);
     Hex: SerWriteParamWord(command,thedata);
     LBP: LBPWriteParamWord(command,thedata);
   end;
end;

procedure WriteParam(theaxis: byte;theparm: word;thedata : longint);
var command : word;
{ full 32 bit parameter write - 2 words }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or WriteFlag or LongFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus:  BusWriteParam(command,thedata);
     Hex: SerWriteParam(command,thedata);
     LBP:  LBPWriteParam(command,thedata);
   end;
end;

procedure WriteWaitToken(theaxis: byte;theparm: word);
var command : word;
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or WaitTokenFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus:  BusWriteCommand(command);
     Hex: SerWriteCommand(command);
     LBP:  LBPWriteCommand(command);
   end;
end;

{$IFDEF COPROC}
procedure WriteParamDouble(theaxis: byte;theparm: word;thedata : comp);
var command : word;
{64 bit parameter write - 4 words }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or WriteFlag or DoubleFlag or (theaxis shl AxisOffset));
  case Protocol of
    Bus:  BusWriteParamDouble(command,thedata);
    Hex: SerWriteParamDouble(command,thedata);
    LBP:  LBPWriteParamDouble(command,thedata);
  end;
end;
{$ENDIF}

function ReadParamWord(theaxis: byte;theparm: word):word;
var command : word;
{16 bit parameter read }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or (theaxis shl AxisOffset));
  case Protocol of
    Bus: ReadParamWord := BusReadParamWord(command);
    Hex: ReadParamWord := SerReadParamWord(command);
    LBP: ReadParamWord := LBPReadParamWord(command);
  end;
end;

function ReadParam(theaxis: byte;theparm: word):longint;
var command : word;
{ 32 bit parameter read }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or LongFlag or (theaxis shl AxisOffset));
  case Protocol of
    Bus:  ReadParam := BusReadParam(command);
    Hex: ReadParam := SerReadParam(command);
    LBP:  ReadParam := LBPReadParam(command);
  end;
end;


{$IFDEF COPROC}
function ReadParamDouble(theaxis: byte;theparm: word): comp;
var command : word;
{ 64 bit parameter read }
begin
  WaitForICDFIFONotHalfFull;
  command := (theparm or DoubleFlag or (theaxis shl AxisOffset));
  case Protocol of
    Bus:  ReadParamDouble := BusReadParamDouble(command);
    Hex: ReadParamDouble := SerReadParamDouble(command);
    LBP:  ReadParamDouble := LBPReadParamDouble(command);
  end;
end;
{$ENDIF}

procedure WriteParamWordQ(theaxis: byte;theparm: word;thedata : word);
var command : word;
{ 16 bit parameter write }
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or WriteFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus:  BusWriteParamWordQ(command,thedata);
     Hex: SerWriteParamWordQ(command,thedata);
     LBP:  LBPWriteParamWordQ(command,thedata);
   end;
end;

procedure WriteParamQ(theaxis: byte;theparm: word;thedata : longint);
var command : word;
{ full 32 bit parameter write - 2 words }
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or WriteFlag or LongFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus:  BusWriteParamQ(command,thedata);
     Hex: SerWriteParamQ(command,thedata);
     LBP:  LBPWriteParamQ(command,thedata);
   end;
end;

procedure WriteWaitTokenQ(theaxis: byte;theparm: word);
var command : word;
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or WaitTokenFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus:  BusWriteCommandQ(command);
     Hex: SerWriteCommandQ(command);
     LBP:  LBPWriteCommandQ(command);
   end;
end;

{$IFDEF COPROC}
procedure WriteParamDoubleQ(theaxis: byte;theparm: word;thedata : comp);
var command : word;
{ 64 bit parameter write - 4 words }
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or WriteFlag or DoubleFlag or (theaxis shl AxisOffset));
   case Protocol of
     Bus:  BusWriteParamDoubleQ(command,thedata);
     Hex: SerWriteParamDoubleQ(command,thedata);
     LBP:  LBPWriteParamDoubleQ(command,thedata);
   end;
end;
{$ENDIF}

function ReadParamWordQ(theaxis: byte;theparm: word):word;
var command : word;
{16 bit parameter read }
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or (theaxis shl AxisOffset));
  case Protocol of
    Bus:  ReadParamWordQ := BusReadParamWordQ(command);
    Hex: ReadParamWordQ := SerReadParamWordQ(command);
    LBP:  ReadParamWordQ := LBPReadParamWordQ(command);
  end;
end;

function ReadParamQ(theaxis: byte;theparm: word):longint;
var command : word;
{ 32 bit parameter read }
begin
baudrate  WaitForQCDFIFONotHalfFull;
  command := (theparm or LongFlag or (theaxis shl AxisOffset));
  case Protocol of
    Bus:  ReadParamQ := BusReadParamQ(command);
    Hex: ReadParamQ := SerReadParamQ(command);
    LBP:  ReadParamQ := LBPReadParamQ(command);
  end;
end;

{$IFDEF COPROC}
function ReadParamDoubleQ(theaxis: byte;theparm: word): comp;
var command : word;
{ 64 bit parameter read }
begin
  WaitForQCDFIFONotHalfFull;
  command := (theparm or LongFlag or (theaxis shl AxisOffset));
  case Protocol of
    Bus:  ReadParamDoubleQ := BusReadParamDoubleQ(command);
    Hex: ReadParamDoubleQ := SerReadParamDoubleQ(command);
    LBP:  ReadParamDoubleQ := LBPReadParamDoubleQ(command);
  end;
end;
{$ENDIF}

procedure ClearICDFIFO;
var dummy : word;
begin
  if CardType = ThreeC20 then SerClearICDFIFO
  else
  begin
    WriteParamWordQ(0,IFIFOReadCountLoc,0);
    dummy := ReadParamWordQ(0,ZeroLoc);
  end;
end;

procedure ClearQCDFIFO;
var dummy : word;
begin
  if CardType = ThreeC20 then SerClearQCDFIFO
  else
  begin
    WriteParamWord(0,QFIFOReadCountLoc,0);
    dummy := ReadParamWord(0,ZeroLoc);
    { this readback is to guarantee that the FIFO is cleared }
    { before subsequent data is written (and lost ) }
  end;
end;

procedure ClearIRBFIFO;
var dummy : word;
begin
  if CardType = ThreeC20 then SerClearIRBFIFO
  else
  begin
    WriteParamWordQ(0,IFIFOWriteCountLoc,0);
    dummy := ReadParamWordQ(0,ZeroLoc);
  end;
end;

procedure ClearQRBFIFO;
var dummy : word;
begin
  if CardType = ThreeC20 then SerClearQRBFIFO
  else
  begin
    WriteParamWord(0,QFIFOWriteCountLoc,0);
    dummy := ReadParamWord(0,ZeroLoc);
  end;
end;

procedure ClearFIFOs;
begin
  ClearQCDFIFO;
  ClearIRBFIFO;
  ClearQRBFIFO;
  ClearICDFIFO;
end;

function ReadQRBFIFOSize: word;
begin
  ReadQRBFIFOSize := ReadParamWord(0,qrbfifosizeLoc);
end;

{$ENDIF FIFO}

{$IFNDEF WINDOWS}
function InitBusInterface(var message : string) : boolean;
var hstring : string;
begin
  InitBusInterface := false;
  if TheInterface = PCIMem then
  begin
    message := ('No PCI Bridge chip found');
    if QuietSetupPCIM(0,PCIMAddr) then
    begin
      hstring := HexString(PCIMAddr,8);
      message := 'Using PCI memory at '+ hstring;
      FLAT_install;
      InitBusInterface := true;
    end;
  end;
  if TheInterface = EPP then
  begin
    InitBusInterface := true;
  end;
{$IFDEF FIFO}
  if SetupPCIWithMessage(0,PCIPortAddr,message) then {PCI-IO has priority over PC/104}
  begin
    CardType := PCI;
    hstring := HexString(PCIPortAddr,4);
    BusInitSoftDMC(PCIPortAddr);
    InitBusInterface := true;
  end
  else
  begin
    hstring := HexString(PC104Port,4);
    CardType := PC104;
    message := 'Using PC104 Port '+ hstring;
    BusInitSoftDMC(PC104Port);
    InitBusInterface := true;
  end;
{$ENDIF FIFO}
end;
{$ENDIF}

function InitializeInterface(var message : string) : boolean;
var numberstr :string;
iok,pok : boolean;
index : word;
modestr : string;
begin
  modestr := 'No options';
  if (length(message) >0) then modestr := message;
  iok := false;
  pok := false;
  message := 'Unable to initialize';
  SerError := false;

  case TheInterface of
{$IFNDEF WINDOWS}
    EPP :
    begin
      EPPInit(EPPBasePort);
      iok := true;
      message := 'Using EPP interface';
    end;
    PCIMem,ISAPort :
    begin
      if InitBusInterface(message) then iok := true;
      {write('PCI base addr ');
      hexprint(PCIMaddr,8);
      writeln;}
    end;
{$ENDIF}
{$IFDEF WINDOWS}
    OSDevice :
    begin
      iok := true;
      message := 'Using OSDevice Interface';
    end;
    OSLBP :
    begin
    {serial}
      TempBaudRate := TheBaudRate; { save final baud rate}
      TheBaudRateMul:=1;      { kluge hardwired for now = dont care for USB }
      TheBaudRate:=115200;
      if SerOpen(message) then
      begin
        if LBPProgSync then
        begin
          iok := true;
          message := 'Using OSDevice LBP Interface';
        end;
      end;
      TheBaudRate := TempBaudRate; { restore final baud rate }
    end;
    ELBP16 :
    begin
      iok := true;
      message := 'Using ELBP16 interface';
      Socket := TUDPBlockSocket.Create;
      Socket.Connect(IPAddr,'27181');
      if Socket.LastError <> 0 then
      begin
        iok := false;
        message :=  message + ': '+ Socket.LastErrorDesc;
      end;
    end;
{$ENDIF}
  end; { Interface }

  if iok then
  begin
    case Protocol of

      Direct:
      begin
        pok := true;
      end;

{$IFNDEF WINDOWS}

      Bus:
      begin
        if InitBusInterface(message) then pok := true else
        message := message + ': Bus interface init failed'
      end;
{$ENDIF}
      LBP:
      begin  {serial}
        if SerOpen(message) then
        begin
          if LBPSync(message) then
          begin
            pok := true;
{$IFDEF FIFO}
            LBPInitSoftDMC(DefaultLBPBasePort);  { not clean move up }
{$ENDIF FIFO}
          end
        end;
      end; {lbp}
      SSLBP:
      begin
        pok := false;
        message := 'No SSLBP hardware';
        FillHM2Array;
        ZeroMasks;
        if GetModuleInfo(SSerialTag,dummyword,dummybyte) then
        begin
          message := 'SSLBP hardware found';
          InitializeSSBaseAddr;
          SetAllHM2OutputMasks;
          UpdateAllHM2OutputMasks;
          pok := true;
          if (modestr = 'Setup Mode') or (modestr = 'Setup Mode NoCRC') then
          begin
            SSLBPChannelAccessInit;
            SSLBPSetBaud(Axis,TheBaudRate);
            if modestr = 'Setup Mode NoCRC' then SSLBPSetNoCRC(Axis,$FF);
            pok := AxisStartSetup(Axis);
            if pok = false then
            begin
              { writeln(SSLBPGetBaud(Axis));
              SSLBPDump(Axis); }
              message := 'SSLBP won''t starts'
            end;
          end;
        end;
      end; {sslbp}

      HEX:
      begin  {serial}
        if SerOpen(message) then
{$IFDEF THREEC20}
        SerMesaStart;
        SerListen(Axis);
        CardType := ThreeC20;
{$ENDIF}
        begin
          if SerSync then
          begin
            pok := true;
            message := 'Using Hex Serial Interface';
          end else message := 'Hex Serial Communication failed !';
        end;
      end; {hex}
    end; {protocol}
  end; { iok }
{$IFNDEF WINDOWS}
  if (ComPortHardwareType = MESAComPort) and ((Protocol = HEX) or (Protocol = LBP)) then
  begin
    FillHM2Array;
    if not (GetModuleInfo
    (UARTRXTag,dummyword,dummybyte) and GetModuleInfo(UARTTXTag,dummyword,dummybyte)) then
    begin
      message := ('No Mesa UART hardware found');
      pok := false;
    end;
  end;
{$ENDIF NOT WINDOWS}
  InitializeInterface := (iok and pok);
end;

{ added halt to bumout 2-3-2010}
procedure CloseInterface;
begin
{$IFNDEF WINDOWS}
  case TheInterface of
    EPP : EPPZeroPort;
  end;
{$ENDIF}
end;
